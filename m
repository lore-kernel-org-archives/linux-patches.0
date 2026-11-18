Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015755;
	b=Apecpug3qbg0WsaxnpLgUx/hwhn48z4TPjpHv8Nk/XobuyM+CJYpdBtnrICuotpt1NfK
	 yd9onI9X5JJPFAwTQKZPilSqAEeE3ElyNVLcvu3oC4Y+J5Jhq3rQcGBAqlSGti2Df8XDh
	 /AYWY3D4DxjB6wnVqt5LEB5ubBzSTWrCJ51Zd54JARb+pi1z8gJAU48giURpgVKka2FQ6
	 8wArheeZ7ahkY6OxiVRGa+IvBEkoBSQQZBgwiVPVikpX8La/pu3WVAVPrRwZW29NzPf31
	 Fy2a3gPkLb/pg0dRXB+1HKNrVKXdcQzojXM1lwjyY8TWE7OF5r94eGSzGwjPb7s4U7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X39Wnmb0/RZW2HV+mKi1bPPGONUrZxRK2hfwDE/x4ak=;
	b=rGQNW094s/kpoFYU7xvmwG4o8v/+SkCeuOJPCn6FH8Tn/oXl+DUcfJFBotcM3AkDIIa9
	 hjYD7PvWpoHYKIBxKCBZ3fAREdP2Rf93gplqKI31tWyJxUM+JAcY+aM8yCUqo+jyYNSTy
	 HGVddHWN3r72Pkzx9i2tfc1pEIa23JNVteS49TKOL1Kd/BAKRFqSvTZ2DcXswEK3pwWOk
	 dRquTe2EW1pWY/odNprP4FlnV4A4qdcxCgKOpgJOI6wuwQ9E2XfAlN07oJ1qN0JYTRnNM
	 FACfHng5xhqcJrFmrA42aVUaQ5I1Di+Zov0sEC+fmMgV9jy0+EVDsR0y7gb5Qz81Qng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zX9iW0lt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6E7606A320;
	Wed, 18 Nov 2026 15:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zX9iW0lt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB3A1F000C4;
	Wed, 18 Nov 2026 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015754;
	bh=X39Wnmb0/RZW2HV+mKi1bPPGONUrZxRK2hfwDE/x4ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zX9iW0ltr9Inq3wy5NhwC/tXOCXpN+2acm8e5ZqC3bxuHlZ53O6ViPD3Est/l0bAC
	 +l2iPvq334yASDwIBzkJWBLpks7SYytlK1XZ8tNgzvCqO5VJah3KjNfgXuhygtqJs5
	 mxRjhsif1U/jsjdvdf5Wz+yPjT7VIWQC5VR2VgoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0285/2651] perf test: Avoid call to missing cleanup function
Date: Wed, 18 Nov 2026 15:25:25 +0100
Message-ID: <20261118150258.169885298@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 4bbcb0fb9b866d05a2dd2db8bccd78be9d0476a9 ]

Cleanup function was removed by writing to /dev/null rather than
temporary files. The exit path still had a call.

Fixes: 44f6b44027910eb9 ("perf test: Fix hybrid testing of event fallback test")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/test_event_open_fallback.sh | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/tests/shell/test_event_open_fallback.sh b/tools/perf/tests/shell/test_event_open_fallback.sh
index 9420a7557c138..27d440a5355da 100755
--- a/tools/perf/tests/shell/test_event_open_fallback.sh
+++ b/tools/perf/tests/shell/test_event_open_fallback.sh
@@ -57,8 +57,6 @@ ret=0
 test_decrease_precise_ip		|| ret=$? ; count_result $ret ; ret=0
 test_decrease_precise_ip_complicated	|| ret=$? ; count_result $ret ; ret=0
 
-cleanup
-
 if [ ${err_cnt} -gt 0 ] ; then
 	exit 1
 fi
-- 
2.53.0



