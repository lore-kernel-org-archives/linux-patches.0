Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057128;
	b=AoqDOtmHfo2NuhK2wFkld2X7cztVdAejNR2d2FrtT1uk9L7Rdh4HXiJbzgODE/xvQqWh
	 Jggwi8aBgReDsi1DsBiji4q9WUDkxxUNNqgp7HPMFF0eG5tByggIZr/Ka42n5K8EHqzom
	 1h5O/Ihmj+bqWHixIE6zDrwIzscnNlaI/rNYcsgJjPq1JYMc0nYhIN/Hy2GDx6bzpUWpP
	 Z5DDYX1HllmtT9LlbDqHXRdcnB++wSdDPv1+v4Ys86mF3E6wRkIVAYP9F3sNl3aPP0u0L
	 luAfe0dudVq5Lip9FXduCMdO/FnKDfe1Zw3CXjKhp4rCb+IM5famyRLJR/YUWxMNgAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MojUUBHdY6rQOKxxcxGebo483nZPJL+330yU22+7bXU=;
	b=0pekZKtmQ5PG89wm+GjrCT+81ldai8QeoZiyIPr47J+m+7TVLGg1YKj4qmG62zVuLSCY
	 +y90AqG5+G5Aypj69qw3nn8K2LJOpyhgg1BxcDIvsBunL4hcgviz/JM+peYyozEqzVv42
	 da/jpQi4o0fOHRtFnNzI2vbi6b24ibUfzGr8cAhuB97Dw/uOmDsVdS7C2xaR4gmJ1gSfX
	 Pvkm/bf01Sk9LotTlNcK9YORMdZI6PPPKyLSK4eo30EIeG3lKMzCvGY0osTtKg58kxgf5
	 xUQip7geLHRPeIWkge8PFRVgZwX3pzHenwzUoInXS2RIkIZ3qKE1GjNh24/fEM9y6aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wqgWkeiI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86ED8606A31C;
	Thu, 19 Nov 2026 02:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wqgWkeiI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47071F000C4;
	Thu, 19 Nov 2026 02:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057128;
	bh=MojUUBHdY6rQOKxxcxGebo483nZPJL+330yU22+7bXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqgWkeiIc6fsPUAZNMqgWh2dCM7U4qKE7IfNv0ZQVaalcZ8MuITIIRtAJwgFEcnm3
	 xsa4SjYrnb2rwHhY3hFegpGauPnOrsDY955P//JoGYQo9f1hG/S0nlgj/LXKtj34dh
	 YXM2900UrNOOs0bfxWc4VrhhseRkmyWjIcnLeH7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0022/1848] drm/amdkfd: Check for null pointer after calling kmemdup
Date: Wed, 18 Nov 2026 15:34:20 +0100
Message-ID: <20261118145912.006955123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit abfaf0eee97925905e742aa3b0b72e04a918fa9e upstream.

As the possible failure of the allocation, kmemdup() may return NULL
pointer.
Therefore, it should be better to check the 'props2' in order to prevent
the dereference of NULL pointer.

Fixes: 3a87177eb141 ("drm/amdkfd: Add topology support for dGPUs")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_crat.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -408,6 +408,9 @@ static int kfd_parse_subtype_iolink(stru
 			return -ENODEV;
 		/* same everything but the other direction */
 		props2 = kmemdup(props, sizeof(*props2), GFP_KERNEL);
+		if (!props2)
+			return -ENOMEM;
+
 		props2->node_from = id_to;
 		props2->node_to = id_from;
 		props2->kobj = NULL;


