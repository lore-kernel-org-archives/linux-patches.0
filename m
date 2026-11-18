Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017227;
	b=rE5yfEPs0+pI3fPfEL7i+CUFogYRp3XzZ24USkf/PernQW8OgGqP+mrLkRWP57XLVetl
	 AEhjVXcX6FoCECMsKN4t32qqfG6YhuuvlpiZgxNOCtIP5Dzg+StopGfmzoEazR0fTj7JJ
	 sQSKjvcRIYh+B2LRfdmGX6JbrwltyZgT6/cQfRFmgjRck2xWe1RxA6jnQv6M4oS0Ht/NL
	 4GMVh3d0xRTyhmk+L+2XHU8mQ8Cb2mmrvIK0chgDDEQpc9fXq+7wztQQR+zbWnOYGB3D1
	 +OuIQLk3Ok7vIUtQMr7kUpwUUOQgRd7WbajGCKXLgTFij7xQ3dDl/AvazelqqgMQSVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DvJhAUuarOizsUytrHHd/lkoqc4esk57fK/7z/SarcE=;
	b=g3hA3s5HfXDg+AZhZQZcdoXj+XsbRljgNEs22JXKSoVYehvsGSaCzZDSKuppOSmz1z4M
	 EPKOq6uZSA32EsYHQJss1AZqHaMPOgyHdCzAkBRHGfJrh6y90IscC8Yi8FS5Wq71lFqUJ
	 0LDAT6WFKE2czzJPszXS/+JNrGmJbSakIg0fbBD82wXn1STmH+p4hrXrj9Bgu0ZIOJrZW
	 Emhv2vH2FItrQezjHPi/YC5N5B6Z0wUvfQNmfjDSltBENnCM89Bn8PJG7xalSR+dOxHxe
	 8LiKfwAKa4qE3NFBK+ANuZhC7ZmS8hPQs5GMCBfAKpnJWe6B8wp0vy08CFqR0XMfXrQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I79v4AZJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7A3606A325;
	Wed, 18 Nov 2026 15:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I79v4AZJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE981F000C4;
	Wed, 18 Nov 2026 15:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017227;
	bh=DvJhAUuarOizsUytrHHd/lkoqc4esk57fK/7z/SarcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I79v4AZJoJTvbXRJDBKVLuD1f/xY40VOdMvMiM4sCWZHhR7ChJNe10UFo4T9dkIX+
	 U63D6Qf/12yjYCl+nw6ZYPXr9ZVlw2HK5zTzik5qyABiPLBqrbHCaDEQZNslUjkood
	 nPlhQP8wpU4yYyp8AUo7Jro78Nr7Xf+ndmmRazv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Leo Yan <leo.yan@linux.dev>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0782/2651] perf mem: Fix size tracking for mem_lvls in perf_script__meminfo_scnprintf()
Date: Wed, 18 Nov 2026 15:33:42 +0100
Message-ID: <20261118150316.041273793@linuxfoundation.org>
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

From: Thomas Falcon <thomas.falcon@intel.com>

[ Upstream commit 06d5ce78e4fea2cf0738da903aa248a81101c155 ]

When printing memory info in perf script, the entire size of the
buffer is passed to perf_mem__lvl_scnprintf() instead of the remaining
size. Pass the remaining buffer size instead.

This issue was detected by sashiko during an internal code review.

Fixes: fdefc3750e847a91 ("perf mem: Print memory operation type")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Leo Yan <leo.yan@linux.dev>
Assisted-by: Sashiko:gemini-3.1-pro-preview
Signed-off-by: Thomas Falcon <thomas.falcon@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mem-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/mem-events.c b/tools/perf/util/mem-events.c
index 0b49fce251fcc..4e490f9cd3488 100644
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -610,7 +610,7 @@ int perf_script__meminfo_scnprintf(char *out, size_t sz, const struct mem_info *
 	i += scnprintf(out, sz, "|OP ");
 	i += perf_mem__op_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|LVL ");
-	i += perf_mem__lvl_scnprintf(out + i, sz, mem_info);
+	i += perf_mem__lvl_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|SNP ");
 	i += perf_mem__snp_scnprintf(out + i, sz - i, mem_info);
 	i += scnprintf(out + i, sz - i, "|TLB ");
-- 
2.53.0



