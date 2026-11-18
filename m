Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037281;
	b=FSjzLoYfUafvizjw10/RdYflkFmGfj/AjT+meizboyZl2vx1/hi/SCI6tsl21tJBrIUH
	 2Hs1bdmQaKwBS5xCRtaTh1xf/ySNJi0CbIR4bqKM6ga4xA+O3MPTmdH0tITUaesGgSE69
	 GrukEAOHtXyVVwT4mQEJ/a6ce5aUDeewvKbL3al7kp7tY4ds1UxRDo4XBTRrSsYVFMBSQ
	 YRYJZDMCVeaEsC1B0I2Wsy0v/r3vbPNBJD/po+OxzzoeJUeArIr0gwLDI8Kz38Q1iSBW+
	 KcMCQ+fWjb45IqmqOb77WNDJgPB4GvmvKBaLjokSV/Pp2nnYOmdXffHZWVZ5JRWpdyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037281;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OkPMZFOrejSGYJvQvZ9LmAM40As/ppLmaqMXXJsXzY8=;
	b=p57VvZqAvzmht9Ej6F7YdxBgYK+h+TzoG6vVRiuRKpPDObJTdBvvhyHUDafH1rdVh4UZ
	 cYWtyBpBrsPt1H/LxAEzeiMhc6twNOxtOiHnNkJMuRkFv7cmQIQ59GHx5s/o7jqCO+wc6
	 rWDtIL9RBLCo1Sk7G8CtFD7DBs3P+onFk/leQ4Gsotdpw0jDyEuhHAS9sn3A17UdSvv0P
	 GpNiFyo2eNL/v6wc8TzcWbgMOeSBJk1cTkoXkEGP5bD8jrK3hmP6KNOHwjdIuNt1cWHeq
	 Dekj5iAmjkUdk7tmgUrPpNXofvOfi6gbnJbdivUPBlPXtObalWXHopO1pW5zfjTZqgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFB5vijE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8D9606A331;
	Wed, 18 Nov 2026 21:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFB5vijE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367521F000C4;
	Wed, 18 Nov 2026 21:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037280;
	bh=OkPMZFOrejSGYJvQvZ9LmAM40As/ppLmaqMXXJsXzY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFB5vijEyF9S75Gt0Sm0D3vt3L6DMqyu8Kw3Kkc5wQhrMO2wLLaiYuQb5mpBKK5LX
	 BB5VaPJme+gbkJB1z/B6TpwKSAgHjp/lqyn1OV397xLo1HQq9ZsXe1bhfcEDS7axR7
	 2JRykoWV58qTdXS99l68tUYM2IOZc1JrKEU/S12M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Schmidbauer <opensource@grische.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1353/3318] net: get stats64 if device if driver is configured
Date: Wed, 18 Nov 2026 15:32:55 +0100
Message-ID: <20261118150401.006649762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 3e2f544dd8a33b2f650b32920b9bef103da2a7cd ]

If the network driver is relying in the net core to do stats allocation,
then we want to dev_get_tstats64() instead of netdev_stats_to_stats64(),
since there are per-cpu stats that needs to be taken in consideration.

This will also simplify the drivers in regard to statistics. Once the
driver sets NETDEV_PCPU_STAT_TSTATS, it doesn't not need to allocate the
stacks, neither it needs to set `.ndo_get_stats64 = dev_get_tstats64`
for the generic stats collection function anymore.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 94b601bc4f85 ("net: core: Implement dstats-type stats collections")
Signed-off-by: Christian Schmidbauer <opensource@grische.xyz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5840a526af08e..a5e9e63b67965 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10790,6 +10790,8 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 		ops->ndo_get_stats64(dev, storage);
 	} else if (ops->ndo_get_stats) {
 		netdev_stats_to_stats64(storage, ops->ndo_get_stats(dev));
+	} else if (dev->pcpu_stat_type == NETDEV_PCPU_STAT_TSTATS) {
+		dev_get_tstats64(dev, storage);
 	} else {
 		netdev_stats_to_stats64(storage, &dev->stats);
 	}
-- 
2.53.0



