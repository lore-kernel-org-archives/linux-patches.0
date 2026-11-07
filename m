Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062788;
	b=XAeM2Z6otAiA6Ct1mG4SMksNX9LcWdd20nh78C0ZbIfqcqV8uagKUPUdFA7sPaQu+Ryp
	 dgEuavXcMd9lS/xwnANixLpYBgY/WIXSfZBp3D81wr5GP4cXMm1kxRFPXwOFLBN6pYAhD
	 H6DHMev4lxPQA/ZODVmip7phesIDSKaaomrMcjHApeLzMF1yMg4TP81WTPhup3GnRJKmU
	 XSNnlWEcFDevhC2/wcG7Gp3yVfDExePJZbaU2Trh/xDAchQ+Z6BzAhIMc0nK72Epm+enx
	 bP8f3LgdVbkoXXZtPXvHf4u6e1M8fNXBn/xzeJv9rWxbWYjD505kQVhqBHqV6fKkyQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W3AEUUs+AI0hYnTl6ovtBxpw0osmgL4MKy88ZUa+1Mw=;
	b=mdL2arSgflSSDu2BxTlBNiDGdz8iJdcFDY2GjxvUWH3a4N3W8wB8Xr+CRmnrhaBYdQvM
	 TddLlyMpR0lhDi/MlElAQngcNo/lssMaVIv/QBlAvnolYkCGHN7YQPMdC+F69i5q1vGBX
	 bSBiyNC05mYCHpO/qlytIAOrRpCW0NQBRO//ZgVOq31HBsY1YHjF4J3TNezwYww1VHapm
	 dApuMKDVF14nJ7Nsx1eVkjwaTZ6uQ/nO2oxhULAhO9437IcwhucalVldk7iJloHPD5urE
	 jWts3ndTXjAPzLifcqYnOAvNKUJYk+pPBLMxVyjZ6YTUgUBFymG57y0JUcwWWz5z+yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0bQi5QG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B480A606A334;
	Sat,  7 Nov 2026 14:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O0bQi5QG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60E411F0089F;
	Sat,  7 Nov 2026 14:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062787;
	bh=W3AEUUs+AI0hYnTl6ovtBxpw0osmgL4MKy88ZUa+1Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0bQi5QGGE+97ygNjnQh5JtZ8IZ0CQzJkk02wYKdavgpHhEEg3idyzkXLFTYYxrvv
	 WNGejvce+RKxqp13/yKqEbSwCNyW3kbOBWL/04ZW9xASU9t8Y9bEEmGYL9WvCyDl0A
	 v2T+Ysva0HN19K3EmBdWHFU9baryRDCStML/yufo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Wang Yan <wangyan01@kylinos.cn>,
	Athira Rajeev <atrajeev@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/869] perf powerpc-vpadtl: Fix off-by-one in auxtrace_info minimum size check
Date: Sat,  7 Nov 2026 08:46:16 -0500
Message-ID: <20261107134855.880139357@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Yan <wangyan01@kylinos.cn>

[ Upstream commit d9c7e2ede92ce258a5d4a6cbc55f75acd379c97d ]

min_sz is set to sizeof(u64) * POWERPC_VPADTL_TYPE, but the code reads
auxtrace_info->priv[POWERPC_VPADTL_TYPE], which needs at least
POWERPC_VPADTL_TYPE + 1 elements.  POWERPC_VPADTL_TYPE is the first
enumerator of the priv index enum (0), so min_sz evaluates to 0 and the
check validates only the perf_record_auxtrace_info header itself.  A
PERF_RECORD_AUXTRACE_INFO event carrying a zero-length priv array then
passes the size check, and the subsequent priv[POWERPC_VPADTL_TYPE]
read runs one u64 past the validated region.

This is the same off-by-one fixed for Intel PT by commit c4362d5e1a5e
("perf intel-pt: Fix off-by-one in auxtrace_info minimum size check")
and for Intel BTS by commit b9fb8225951c ("perf intel-bts: Fix off-by-one
in auxtrace_info minimum size check").

Use sizeof(u64) * (POWERPC_VPADTL_TYPE + 1) so the highest accessed
priv index is covered by the minimum-size validation.

Fixes: c4bbd4ec2e50a9ed ("perf powerpc: Process auxtrace events and display in 'perf report -D'")
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Wang Yan <wangyan01@kylinos.cn>
Cc: Athira Rajeev <atrajeev@linux.ibm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/powerpc-vpadtl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/powerpc-vpadtl.c b/tools/perf/util/powerpc-vpadtl.c
index 55b9b6e070746..eacc845ebda26 100644
--- a/tools/perf/util/powerpc-vpadtl.c
+++ b/tools/perf/util/powerpc-vpadtl.c
@@ -681,7 +681,7 @@ int powerpc_vpadtl_process_auxtrace_info(union perf_event *event,
 				  struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * POWERPC_VPADTL_TYPE;
+	size_t min_sz = sizeof(u64) * (POWERPC_VPADTL_TYPE + 1);
 	struct powerpc_vpadtl *vpa;
 	int err;
 
-- 
2.53.0



