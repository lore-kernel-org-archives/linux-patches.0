Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3135930C624;
	Mon, 13 Oct 2025 15:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368283; cv=none; b=thYsGdtNG301/UPuXAz7DPgkQUo0Jhk3p6NNlat6aQhPvz5/+Qv9MqR49CjY/qmqy6Oq76IXkudsbDjERmOPTlYDgMd+86IRPbsuSCIXxfUIvJSBtZ0BXw75Tkw3N00ldJ9l4gPJ2hD0TSeMFRFPy/5ZmVqI4R+zNIQQzziLBys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368283; c=relaxed/simple;
	bh=ihTj8WGjg8MDAXw1fCR5ThdAFlmxE59iBS3s4t0P7qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8h53s1Zx7LiLs8kjjR8HxoeH5O2WobaFoVfkuj+YS1eVFZDASRYIo2N9oBmlk7dZBjYuJyF8FJJGuWlXvGyPS80oHe06Di3JFq7qVX6S3F7tk5DPAu+sBj5fmxQNsenq0UeqDIPsu1OPwHX+9bUF99cQdGOFHpFPjcU9Xf5OJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0TkAtPs3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0TkAtPs3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7DEC4CEE7;
	Mon, 13 Oct 2025 15:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368283;
	bh=ihTj8WGjg8MDAXw1fCR5ThdAFlmxE59iBS3s4t0P7qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0TkAtPs33eX3iLEbkXQcWKsyBvCrRBL9XhHf2Tx36C1PfapISd4DtaDjAZjbple3S
	 XSWCme/7QB/nrj3Fwk3/2ZBZKnfV17ciWm02hvXsBM7awMW7Ugc4kqHDc1KGj3yeYY
	 aY5W06nRtxXQrUVsRTrYWuP2Qbbh1A9BMTJQxyfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhilesh Patil <akhilesh@ee.iitb.ac.in>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/262] selftests: watchdog: skip ping loop if WDIOF_KEEPALIVEPING not supported
Date: Mon, 13 Oct 2025 16:43:36 +0200
Message-ID: <20251013144328.790702764@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a1f506ba55786..4f09c5db0c7f3 100644
--- a/tools/testing/selftests/watchdog/watchdog-test.c
+++ b/tools/testing/selftests/watchdog/watchdog-test.c
@@ -332,6 +332,12 @@ int main(int argc, char *argv[])
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



