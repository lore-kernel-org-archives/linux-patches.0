Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51C6330D58;
	Mon, 27 Oct 2025 18:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591112; cv=none; b=Faj8F6iqjKr/XHyD6f/mkNce7xnf9yOtMLNG75pIpzBfkUltjI6dH6AFblyHzGZq3BgDR5PCTiOLqRNxAtVPiWtICTERR32vqlwAXWZuyOvw3o2eDmRtHC1CPLPohB/8Oup1dPWS1PgvOzs/f0rtaRrCRoYnL6T75xSm1o+CCIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591112; c=relaxed/simple;
	bh=nuYRO0l24651J+bDgMWy83U5Y4JetArlHVW85tKLffI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnoQVprz0+zyjcthG8pLMdrXxqy8nlaRlW0CMSZ2jiRvhKtQy+nz3SnFyXfbtakPxFBm9spb/eW0YvXB3jDNqOlpgaaN57oRDAuX2MTecYXrl6i6eVZYUPxPMSIx+XoV2ePV8wTNRfj+Lbexj4Wz2kf8ZRB/m1ytgMq/xBGwXy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JN2J5R/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JN2J5R/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F78C2BCB1;
	Mon, 27 Oct 2025 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591112;
	bh=nuYRO0l24651J+bDgMWy83U5Y4JetArlHVW85tKLffI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JN2J5R/aso/l2xkaf5H92Ns+ZIXXeiK40LXCr7DH1pCQtCkKzp4Pv64KTwsC2ICVr
	 ujTZOqYLiT5LzzNh+6zAcIcWSGSS06DrcW5rBV7Toapc4Srl29xhaIlSBbUQHNSadi
	 FrT1XjP+GmACaFrKxf3oeq/xk6hrzz8lGKZ1bOSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhilesh Patil <akhilesh@ee.iitb.ac.in>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/332] selftests: watchdog: skip ping loop if WDIOF_KEEPALIVEPING not supported
Date: Mon, 27 Oct 2025 19:31:28 +0100
Message-ID: <20251027183525.548404374@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



