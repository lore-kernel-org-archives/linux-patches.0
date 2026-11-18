Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049549;
	b=uubse9dQyZ9kTNSHHWSAEsJGrruEitRSrkXOKUC3iP9Tk4tL6tQ+WK5o53uenzQzzITf
	 b0B9WKmHWVrB03TeTIZo/zkEea8W6Zj3RrREpmWe/bhcaSg21QxlLIDJA2K79MY3pW7cK
	 YqFsrhz73+Ww/KhYD6xuMDHkuOZf+KqhAn5eub8s2pLOwcT318GY9nOuxfkkIM2bh9q6W
	 nVkmveAChDPubfwSzHtJJpWix47wGGVz3YQXhbg4pAesF55KjyTWdsmrJLwgNfG+Lu4rk
	 09VSMIUro4CmLpDigMRNI1ZBoSoFhSkLZO6/tPYWlj6qNgKSR+Jij33gsUz3S1kUUNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=thNKDfBJ3rXiL8JGHJhIaQV9WjHOEV90j3rAzq7l4Cs=;
	b=pYTOMsYYjEdULF6b1k2/oywwlW5nkXldWrsaCMak1qAYLiUKpsmOaIGxZ3bw+Ev1MugH
	 0Dug1+3viQ7dso4SPmO5CwSUlcsm1Dl6+0p1OFz3GvXRY6tZ8Fh/o/7QlM8lc4TlnZQFw
	 xnEH4JgpqH958mwHl3bQtD8Jp99LIuHt9B81iwg1xlbUZb56TUiTnDTfBFMftzyfmduOe
	 A5eQwRm68NHlXqLUMyEJ5PhntPyYkT4Pgysk46DHkR+wk5iqRqjWfLKyR14/Gxwgcp9Zg
	 uAqLfhMj4t7BouhSOhgU8StDL6CmcMnOybGJLKjtAPy5Ka6gH+CBGrQ2FWY/Qpy8c7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="POg/hYtE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA770606A31C;
	Thu, 19 Nov 2026 00:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=POg/hYtE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5DE1F000C4;
	Thu, 19 Nov 2026 00:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049549;
	bh=thNKDfBJ3rXiL8JGHJhIaQV9WjHOEV90j3rAzq7l4Cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=POg/hYtEFq4HIzmqydGzKjnPy1Q5oO7RhJkja2vCwXhwAcYhv6hX/mARgca+8FDOt
	 Cv+eYgtFs4kXvbnj6VGqMH2mENjALR1Mnce8D1aoRDOKW7zYgLZOuyhcq1w7ZLT5SW
	 jgya5GAyn/MbwTqk98OzXXncU6Hz2rhmZzsQT+uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2390/2857] platform/x86: intel_telemetry: initialize default trace verbosity
Date: Wed, 18 Nov 2026 15:57:04 +0100
Message-ID: <20261118150327.580055602@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrova Alyona <aga@itb.spb.ru>

[ Upstream commit 1b55ec81926eb7f6e4fad692fa4040a569e9daf7 ]

telemetry_def_get_trace_verbosity() returns success without initializing
the output verbosity value.

The default telemetry operations are installed when the core driver is
initialized and again by telemetry_clear_pltdata() when the platform
driver is removed. The telemetry debugfs files can remain available after
the platform driver removal.

A subsequent read of pss_trace_verbosity or ioss_trace_verbosity calls
telemetry_get_trace_verbosity(), which may use the default callback and
return success without setting verbosity. The uninitialized value is then
passed to seq_printf().

Validate the output pointer and initialize the default verbosity to zero
so callers never use an uninitialized value after a successful call.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 378f956e3f93 ("platform/x86: Add Intel Telemetry Core Driver")
Signed-off-by: Aleksandrova Alyona <aga@itb.spb.ru>
Link: https://patch.msgid.link/20260917110812.2831-1-aga@itb.spb.ru
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/telemetry/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/intel/telemetry/core.c b/drivers/platform/x86/intel/telemetry/core.c
index e4be40f73eebf..6a1e9df26ba1b 100644
--- a/drivers/platform/x86/intel/telemetry/core.c
+++ b/drivers/platform/x86/intel/telemetry/core.c
@@ -51,6 +51,10 @@ static int telemetry_def_get_eventconfig(
 static int telemetry_def_get_trace_verbosity(enum telemetry_unit telem_unit,
 					     u32 *verbosity)
 {
+	if (!verbosity)
+		return -EINVAL;
+
+	*verbosity = 0;
 	return 0;
 }
 
-- 
2.53.0



