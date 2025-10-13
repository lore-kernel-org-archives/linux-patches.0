Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9472727E3;
	Mon, 13 Oct 2025 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367070; cv=none; b=czFA/M6Xdpt9D1TQeI2gx9IPEoAASWTFtnGmQh20/1rgGEjpNtK17nhCz9ogLCRZLfU+TJxc7QfYV1xA3pu/IKUI8OqVEaXc349FY5mLuFX7j1ChBWxxageOPVMRSOocpeRTN4Uy09X/ztvURO/3xm2LvYVyyiZU+y4IyVKREao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367070; c=relaxed/simple;
	bh=2DonojuFFLQbJo9qmAXhS5f4D8wlIqpTwlaQPctx6uY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5C5VVSDjcksQyD1lQt5vpzi/rBqR58Hl9b5TOmYse1M1+C87peolEHOEw4ytLnV8B2LdRNj1MwO5m0oLeOSbnWdTsrK+Bb4v7u04Osh+heYsI8SQmCnJz02p+1tXkvjz4wo14f5wrg5fG6INBuHUDnA0o9Yrgg/FXBNFUWnC9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iRhX+VpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iRhX+VpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B2CBC4CEE7;
	Mon, 13 Oct 2025 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367070;
	bh=2DonojuFFLQbJo9qmAXhS5f4D8wlIqpTwlaQPctx6uY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iRhX+VpArbpKOPREU7XCAN9X3TcKBjI+hozAR0O5MeLizEb13zfIQ44JVMYmf1wY3
	 PdCZb8tsPu9vSVBBYeYqBko6UeTebjnJMONWJRcgNEFs8Cy1HPsG4ZL6ea35uAk1LN
	 GcAKloD+a66gaR3m4so/zUk7fjrUoQSBNp0GnU9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhilesh Patil <akhilesh@ee.iitb.ac.in>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/196] selftests: watchdog: skip ping loop if WDIOF_KEEPALIVEPING not supported
Date: Mon, 13 Oct 2025 16:44:13 +0200
Message-ID: <20251013144317.469272238@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



