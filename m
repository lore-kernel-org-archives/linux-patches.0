Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7772EDD62;
	Mon, 27 Oct 2025 18:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590391; cv=none; b=KQYV2bMqQA3N5bhTKJv92IsexiNC/t+LNrW/8upm8m627g7w9Q7lGpdwXu9FepApN8fZ/Zs4YwzXZC9XLkWem5kuQwn9JNaeM8p9bOWcBFNhqsEnWAHS2/QSIbWKOpLnO26ykCoisJLw+TYxth+c4NRxymYYvt3+LNHRBThO2aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590391; c=relaxed/simple;
	bh=G2/1SOUx/QFTHNsB1+W8NeLaBanos3bLWAbfeyfu7JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXh1VuHHpDUDJ7L5NA0GjYAYUaCLfoG4R5UpKlcPQsWMhkRpkYZz7e68EhXlWNJAf/t3XFXkkgTTKA895pDY6L7HAk+uXLi7BBZmmRtLvtKvk1T/4B2kEWgbEiUXTNr/yCeNgkOWec3AwQoXfG3M19fJY6mW6pVGaqHsftCkAzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w6PnISe9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w6PnISe9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEDC9C4CEF1;
	Mon, 27 Oct 2025 18:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590391;
	bh=G2/1SOUx/QFTHNsB1+W8NeLaBanos3bLWAbfeyfu7JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w6PnISe9n+4f+jkxFTmJBR+FTRRAP1PkPtFFScclzt24btkEesJh+XvknRPMdep4L
	 iJh9s7AApplIq/FD3x7KItFTyD23WiiTuPSJk25jKtkY9txaXWAsKAR+5yHZxxt/TO
	 qE4YkHxnreGVGxRCFNEBFcz27+GkKCwDkzCOhsYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhilesh Patil <akhilesh@ee.iitb.ac.in>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 027/224] selftests: watchdog: skip ping loop if WDIOF_KEEPALIVEPING not supported
Date: Mon, 27 Oct 2025 19:32:53 +0100
Message-ID: <20251027183509.732084708@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhilesh Patil <akhilesh@ee.iitb.ac.in>

[ Upstream commit e8cfc524eaf3c0ed88106177edb6961e202e6716 ]

Check if watchdog device supports WDIOF_KEEPALIVEPING option before
entering keep_alive() ping test loop. Fix watchdog-test silently looping
if ioctl based ping is not supported by the device. Exit from test in
such case instead of getting stuck in loop executing failing keep_alive()

watchdog_info:
 identity:              m41t93 rtc Watchdog
 firmware_version:      0
Support/Status: Set timeout (in seconds)
Support/Status: Watchdog triggers a management or other external alarm not a reboot

Watchdog card disabled.
Watchdog timeout set to 5 seconds.
Watchdog ping rate set to 2 seconds.
Watchdog card enabled.
WDIOC_KEEPALIVE not supported by this device

without this change
Watchdog card disabled.
Watchdog timeout set to 5 seconds.
Watchdog ping rate set to 2 seconds.
Watchdog card enabled.
Watchdog Ticking Away!
(Where test stuck here forver silently)

Updated change log at commit time:
Shuah Khan <skhan@linuxfoundation.org>

Link: https://lore.kernel.org/r/20250914152840.GA3047348@bhairav-test.ee.iitb.ac.in
Fixes: d89d08ffd2c5 ("selftests: watchdog: Fix ioctl SET* error paths to take oneshot exit path")
Signed-off-by: Akhilesh Patil <akhilesh@ee.iitb.ac.in>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/watchdog/watchdog-test.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/watchdog/watchdog-test.c b/tools/testing/selftests/watchdog/watchdog-test.c
index 09773695d219f..4056706d63f7e 100644
--- a/tools/testing/selftests/watchdog/watchdog-test.c
+++ b/tools/testing/selftests/watchdog/watchdog-test.c
@@ -240,6 +240,12 @@ int main(int argc, char *argv[])
 	if (oneshot)
 		goto end;
 
+	/* Check if WDIOF_KEEPALIVEPING is supported */
+	if (!(info.options & WDIOF_KEEPALIVEPING)) {
+		printf("WDIOC_KEEPALIVE not supported by this device\n");
+		goto end;
+	}
+
 	printf("Watchdog Ticking Away!\n");
 
 	/*
-- 
2.51.0



