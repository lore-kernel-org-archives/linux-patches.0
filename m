Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044072;
	b=b+CpB2A95DMWbldY89DZblscICcaKsTQ6Ul6BbluQQEgOwmzyOCkbE1eJvlmINWW0/2J
	 SfEbabGSDQEEjh218e7qQy6pu+sZNfv6OOsa0fhyjoS+PL6ZVMuBFe991MeCwjPLO7gVt
	 uWn8eKKPC6HcW3AYI4EHEAlvL5xaH5nx9tqtL0QbWswDDM+QSUcjlQfhEJ8ww28v2/Qhh
	 iSeAfwikCLnXjTHXbCtNO/zzn2+IakvUYJS/NtFCBe4lJPw/9jpXWPz3F8WKjtoSOLuUy
	 tV0qbwkodLr5apmnEAx8wuKFB57zjBmyo88PEDS8ni3NzpzNyMEy9xsRBx25+gdv8lw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Eax8dcdCFz3cQSK1B4zIDSLwDr0iuLItIBAIblos+ng=;
	b=VDvxrSJXXwjDr2Dkt1fDtiWRkgOmamhGXoaCa74GdFL+oWEh+EXkjHgVE3qFyt7QiKi+
	 SL/J2q7bTxeLxLes9Oq5X/fxXjpy2O6FhDpZFhNjchQ6H3bxSbUE5WtguTiX+e+ZwID+I
	 w4oZBlvlMG7FM+lYtNKXD9sIT7pYFe1pSeUmCcymqos82vYWV5tEStS50SSyJREkxT43r
	 r03q3wTrKYcjZbTsSbIoGS5l90CR1DUo9auH2QgN2GHb6DAQe1TcddSiD60Ujvn+vaZH0
	 bvxh72Elk6sDfGWAkkgiGl9na7z+N1sS00M3Iq6OoueXyTDlX9ZZvBTGHgMLF3HuQrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osdOsUFD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6040B606A31C;
	Wed, 18 Nov 2026 23:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osdOsUFD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73171F000C4;
	Wed, 18 Nov 2026 23:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044072;
	bh=Eax8dcdCFz3cQSK1B4zIDSLwDr0iuLItIBAIblos+ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osdOsUFDCZD6KZPKG0bcHlkBcrbGJBMRRpYdM3Ph/GT8IbPqk7lnBDz0Qa3ij9QI1
	 EehQwkbPNx+P7STHe6TjiW7rU85uSIUSyoG0BUcoPrD/9HgCJtMr57mGObjOKVpO5K
	 DjT1IvOZ9O1RL+Mtsv5jwyPsmXrnndRNpSkSzT5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Russell <kent.russell@amd.com>,
	David Francis <David.Francis@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0437/2857] drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc
Date: Wed, 18 Nov 2026 15:24:31 +0100
Message-ID: <20261118150217.115382089@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Francis <David.Francis@amd.com>

[ Upstream commit c883d0a132d430ef7ebb23fd94323be94d0fbdb8 ]

The low 6 bits of cp_hqd_eop_control store the base-2 logarithm
of the EOP ring size. This was calculated as

ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1

But ffs can in theory return 1 or 0, so this could underflow
(although in practice the ring buffer size cannot be less than 4096).

Change this to

ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4)

using properties of logarithms.

Reviewed-by: Kent Russell <kent.russell@amd.com>
Signed-off-by: David Francis <David.Francis@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4f18c56630383c14bfc6b2d65f88f2f895d2121a)
Cc: stable@vger.kernel.org
[ sashal: Dropped the v12 and v12_1 hunks (files absent) and applied the ffs(size/sizeof(unsigned int)/4) change to v10 and v11 only, without the newer size-zero ternary guard in the context. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c | 2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
index d3e2b6a599a40..00c84048860fa 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -192,7 +192,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4));
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
index 4f6390f3236ef..d679f7d68acd2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -218,7 +218,7 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * is safe, giving a maximum field value of 0xA.
 	 */
 	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int) / 4));
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
-- 
2.53.0



