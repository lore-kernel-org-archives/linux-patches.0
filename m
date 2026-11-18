Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017917;
	b=VUBw3iKtZZdZYDFyEA4o7ZPwRGXGwgvkY+rF28/EpudqOX+zAmSuNDvi/kQkeTjn2p3T
	 hVn1CmIcc6V0tNX3URS0JGSjDjjkejtbmjz4/bwh+IfrxAmeLKRbAOh6Ps7v04D0hVu/f
	 g3V9Y08kw4oXSjh338NIjeGrai2r7M4XevmpdRfjg2RCyHVdINlNTOnbU6m1ogMf/1M+p
	 DgSriOA74GUcM4JYepTDDwkQLKa1xwxKBVKFGFuviSHL7kIxfqtisCUs80XtM6MPOCgzd
	 pqywIPN8wiaQfQVFKFw9CRwcX+U4nh0ZoANgKGnm9M3p18c4omrLGWQCDd5rYtnQ4ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VzmjLrpcb3kZ5iXgdYS485OHxuxRDrsMZXSRy+QKa+g=;
	b=oetmV7A8hH9g3BTW1NnIW+dmFhXt0hfv7eVnhpnZ+fOeVGDb3hbi4jBhsxvB/9L0EELV
	 /RiwmMHoSf4Q+T4yaEkRDxuW4chzSTDhiH3pPesGP/WkcOra4rDun70uGbQOLR43KHcu6
	 UaefYQieo9P4KBe4Q0XinK6RDET8b5v2Lw0Euxd8mbXaN4wSRxv1Vf4G//Wgx8boTrxym
	 NkdDSeRqbOQHrA0vz1mfWhp6Vyjc25De3h399wcQPr7MwLxiBvmCyDWa9/jVyQDR+3S/b
	 W3BJwa9ixAz206eG9zqPU0l42XGpXTWaxDA/a77z8hArN0e8kWImKPQIeYMc34F6qtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDOkNv5n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EC7606A31C;
	Wed, 18 Nov 2026 16:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pDOkNv5n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F331F000C4;
	Wed, 18 Nov 2026 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017917;
	bh=VzmjLrpcb3kZ5iXgdYS485OHxuxRDrsMZXSRy+QKa+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pDOkNv5nYxJl9E7DTR1j/TvG/RS8mjAsVDY8CiLGjdh3ndhxW9Sqp6MIDjWon7jcB
	 1/Y1MB8xA8EkGduT80+eC4R8yOua6ZSC1Q2zF4uxoJVuxFVCf0AuW7Evjv6xRRv2WK
	 xuu5GJ7FvqaojC50sHMZRhPb7alH5cIycrMzfYEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 7.3 1056/2651] RDMA/selftests: Fix the kernel config fragment
Date: Wed, 18 Nov 2026 15:38:16 +0100
Message-ID: <20261118150325.991037980@linuxfoundation.org>
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

[ Upstream commit f5d4cc88371feb9c5f96b6fb7fce5e8cb08ecb6a ]

The config fragment lists bare option names with no values:

  CONFIG_TUN
  CONFIG_VETH
  CONFIG_DUMMY
  CONFIG_NET_NS
  CONFIG_RDMA_RXE

which is not valid Kconfig syntax. When the fragment is merged, for
example by "make kselftest-merge" or by CI systems, the lines are
rejected:

  .config:5514:warning: unexpected data: CONFIG_TUN
  .config:5515:warning: unexpected data: CONFIG_VETH
  .config:5516:warning: unexpected data: CONFIG_DUMMY

and none of the options gets enabled, so the rxe tests skip or fail
for lack of the modules they load.

Give each option a value. The scripts load and unload tun, veth,
dummy and rdma_rxe with modprobe, so build those as modules.
RDMA_RXE also depends on INFINIBAND, and rxe_rping_between_netns.sh
runs rping, which needs the RDMA CM userspace interface provided by
INFINIBAND_USER_ACCESS, so add both.

Found by KernelCI kselftest builds.

Fixes: e01027cab38a ("RDMA/rxe: Add testcase for net namespace rxe")
Fixes: ecdcc8a455b7 ("RDMA/selftests: Add rxe_netns_names test")
Link: https://patch.msgid.link/r/20260927161655.1184153-1-sashal@kernel.org
Assisted-by: LLM
Signed-off-by: Sasha Levin <sashal@kernel.org>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rdma/config | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/rdma/config b/tools/testing/selftests/rdma/config
index e1ff54ec0f579..1be43c4274bb8 100644
--- a/tools/testing/selftests/rdma/config
+++ b/tools/testing/selftests/rdma/config
@@ -1,5 +1,7 @@
-CONFIG_TUN
-CONFIG_VETH
-CONFIG_DUMMY
-CONFIG_NET_NS
-CONFIG_RDMA_RXE
+CONFIG_TUN=m
+CONFIG_VETH=m
+CONFIG_DUMMY=m
+CONFIG_NET_NS=y
+CONFIG_INFINIBAND=m
+CONFIG_INFINIBAND_USER_ACCESS=m
+CONFIG_RDMA_RXE=m
-- 
2.53.0



