Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C832330B04;
	Fri, 17 Oct 2025 15:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716115; cv=none; b=X9cNDaKUw5pX4LKOsg7vOoZbrnokkmiOMbZCNOVrTMtN2cvWJeHyA559+A981VVh6iLCdsUvOQafcwvrow5AMaWxUcrY3ScQuRCBl0wLC3ST2xzQstspEKEkYClpjX/RDcbMUWPhNuyztLqerWxHwX0y3paizsTXopjhmtNFR2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716115; c=relaxed/simple;
	bh=7vmZjezO3AIBblq7USCH5XVMgRlMQMS53JGX4mWJzhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pc1EQ2EzfwEsSMLd05qcEUWvMgxOwnPlCsZCrhaVGhDpIpyPOiSwx7vq5NfVc/xmfMktXjpOWorp966mhndHWGCYTt1FdkHSaTX0qL0HnOY2srRE4zLLjYV6MCjIc2ODpInN2MlJ51L7Cd2v4+jfKWMcM50PNFNBU1+uSkJyMPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wnv8FX56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wnv8FX56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EDEBC4CEE7;
	Fri, 17 Oct 2025 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716115;
	bh=7vmZjezO3AIBblq7USCH5XVMgRlMQMS53JGX4mWJzhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wnv8FX56f4vjtSPPe9GF7BRRrQCwl5DtLZt1hU4LX55Ei6RgXYBEbF/gdLOAJFzqp
	 MpIvJCp7mBLM99QzpOnykmFiRY6NOeNcihfwEZ86FTXswFzoEYTdEbPzto2Qj5xPj8
	 8ctQuA1M7lIQ7wNeMeE8NYwLQhu//Hdk3LlHc19s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhilesh Patil <akhilesh@ee.iitb.ac.in>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 045/276] selftests: watchdog: skip ping loop if WDIOF_KEEPALIVEPING not supported
Date: Fri, 17 Oct 2025 16:52:18 +0200
Message-ID: <20251017145144.049028021@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



