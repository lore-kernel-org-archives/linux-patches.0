Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034872;
	b=tl7ypN6xPUXNOqxjHF6PAYaxqxI5facjI/WSfwvp2RSN7uJqti49YHLssPIXF6qGnOQ6
	 onT+4knLYk0VgUCL+fQGsJ2AIjC503yxXs55w6XzMPu/lPG1+P0017aSDyBjYchDgOpQN
	 HfW7mZLDhtG6TULFwI2B6Xl9NMZyg1fRZcV1aUM1Z9V/K7LoCMPTSv8Y9PQPPQ0EpeTZr
	 r/1Pyuvt1tShUUP6bOsqKn9ro8zwVE3pGYcvsx2yt/o9PPGxSwf2ySv1YxHiCiy+k/Inj
	 FUvqCI5yFP2y0QvUghkPN474zc93lyCGvB33DvpKgfTqd1eiT8nv+eieYF/AuiaNIlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034872;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dvhLc8CPDKbb17O2zPGZ/n/lmKBK0BajhcVJlTKdYic=;
	b=syTuGEV4fJLC7UOSQCW7Yu/F+VrbTwvqIG9E2GFBTNss7sGZj55dwRmgZu9JPds59HzM
	 vk0Aq8qXQbRcQDYRf3dUFN6NZxQt79Avf0yDx+XyBl3EBxJ3yzPJY2z4HJPUF0YuOwS4D
	 radCKYsFI+p+EqzxwIQIDSuBHktahzFnUcomhOef0wxv/uGK2E9VmCZ25PKlCKSVyIvAj
	 ugJT24CSeK/9lXryvyQwkbtwXbd2tIUH4E3itr8hLfJew1nGdotK92kFTki5amI9G3xN/
	 NjGk5Wbov3AkS6zhf6N2TN7lNnkmwOV4V3Y7VzTlJRa/eHkD8X8X12CUjsyZBWl03Ow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLyF44gq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2813F606A320;
	Wed, 18 Nov 2026 20:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yLyF44gq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374DF1F000C4;
	Wed, 18 Nov 2026 20:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034871;
	bh=dvhLc8CPDKbb17O2zPGZ/n/lmKBK0BajhcVJlTKdYic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLyF44gqSeh27uT36m7QIThmqiG8lpD9uzkXO/geCG4BZOSFF6JsLmOGyEI+pxao2
	 dRM/t5hdU1HhpLjyIvO7xepiEPe0zJXUapy+e5qBWN/IHSHj6U6xmhLwN/EEOeSsT5
	 AMnY/1kSQK+A2Rpb0vOAkk15e1bbXF9cXfcqm6nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaogang Chen <xiaogang.chen@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0487/3318] drm/amdkfd: Guard m->cp_hqd_eop_control setting by q->eop_ring_buffer_size
Date: Wed, 18 Nov 2026 15:18:29 +0100
Message-ID: <20261118150331.592595260@linuxfoundation.org>
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

From: Xiaogang Chen <xiaogang.chen@amd.com>

[ Upstream commit 8cd2ea7bab77b7aa087b1a6cc26d2df03c2a6ed9 ]

To avoid wraparound if the value is 0.

Signed-off-by: Xiaogang Chen <xiaogang.chen@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit c0cae35661868af207077a4306bc42c7c972947c)
Cc: stable@vger.kernel.org
Stable-dep-of: c883d0a132d4 ("drm/amdkfd: Avoid integer underflow with ffs in EOP ring size calc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c | 4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c | 4 ++--
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c  | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
index 22cbfa1bdaddb..2c9e88d147cb2 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v10.c
@@ -196,8 +196,8 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
index 774dbc204bb82..5a31e8d7798f8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -250,8 +250,8 @@ static void update_mqd(struct mqd_manager *mm, void *mqd,
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control = min(0xA,
-		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1);
+	m->cp_hqd_eop_control = q->eop_ring_buffer_size ? min(0xA,
+		ffs(q->eop_ring_buffer_size / sizeof(unsigned int)) - 1 - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
index 3e1a574d4ea66..ad3a47b175413 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_vi.c
@@ -209,8 +209,8 @@ static void __update_mqd(struct mqd_manager *mm, void *mqd,
 	 * more than (EOP entry count - 1) so a queue size of 0x800 dwords
 	 * is safe, giving a maximum field value of 0xA.
 	 */
-	m->cp_hqd_eop_control |= min(0xA,
-		order_base_2(q->eop_ring_buffer_size / 4) - 1);
+	m->cp_hqd_eop_control |= q->eop_ring_buffer_size ? min(0xA,
+		order_base_2(q->eop_ring_buffer_size / 4) - 1) : 0;
 	m->cp_hqd_eop_base_addr_lo =
 			lower_32_bits(q->eop_ring_buffer_address >> 8);
 	m->cp_hqd_eop_base_addr_hi =
-- 
2.53.0



