Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060598;
	b=wPU8nWQUE8XSnxOQ6Jcfx7o1Wr2mJoI7aQFtDtPDbmUVyeUSjCZt/alGh2P0Mev1pACM
	 1qftFf8w1hrppG7CoB+E44Dt0el+KjwC68z2G5o4VkdBBnZK60DT2eRlUmv1ASQMk9s0b
	 J1U1L72i2/fji1mmGZ7ZrDWmn7v1Kby+2E/Tm44KVXJTwIIN1iqYmOfcByV5msQFwbeWp
	 KzCN1f4L9H6LGc+qa4g1vfioU3469QTlfuWSePxky7q+OGBPZ7TKM2ytwlYipTgemhP2w
	 9swCwidnlCSSYsLn5j6ZgBjI53JvYicAcuWR7lBXFAHN5AHXTbVwUc7jsQDH6Z5aJYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060598;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HVETWmKdr9E0y8cGNbDcON7Ij4R0NqZUlOfAcK2+VCA=;
	b=xlLT5AfyZH+7/O3F/3n4b5poOV0fzogd5USMvlkcsitp4bh8QO2ZuUXQaAKT2BqCNrYI
	 zaophGT+yojMkGSTrTQtPpDNCcAlCKP9oGJbynZ7wQKI8ox4jy5fsvrk8hte6A9TEyuyj
	 CR/QnvSuUecNKlOHy3wE6g+anPded8KlHpUhX84K/fNJXF7Uz1pQc9joIGbtYmH67Ub7g
	 pwdlm6uZveIU3uV1NVUvFsFx6IW/tQQ0WSkWbGuIqC2snkkUAosu2GjMepwOuAi3neYj6
	 e4OAzObM5V3cE1svLYsvtBOABDc37vNQOlvLn0pRWjxCDTZTcEnmgab3Ab83NNl4fig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nevzsgif;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DAB606A326;
	Sat,  7 Nov 2026 14:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nevzsgif
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630921F0089F;
	Sat,  7 Nov 2026 14:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060597;
	bh=HVETWmKdr9E0y8cGNbDcON7Ij4R0NqZUlOfAcK2+VCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nevzsgifao/zslDYSL2u5WunWhyZd9NAF3Q3RjyuM97n3xOP3X/effbcEFoeTDxOs
	 VG6EcgNZaClMdjnr16yX+8c/8b9U0REQjB0Dn90ttIFz9oGveQw5q29iGZg7vdin+u
	 F4sRgZkskEHNlP48hz4GoS9/p2Rnt3H9GxcZOEwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0053/1536] drm/amdgpu: Add checks to vbios fetch through ATRM
Date: Sat,  7 Nov 2026 08:34:29 -0500
Message-ID: <20261107134959.147934676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 8c3fcfc14fc1320a1155acb2dd7656fce7003bc0 ]

Check if a valid buffer object is returned after ATRM call. Also, match
the buffer length against requested size before copying.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
index dec312b0f3b0a..f28dec3630de5 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -280,8 +280,14 @@ static int amdgpu_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
 	}
 
 	obj = (union acpi_object *)buffer.pointer;
-	memcpy(bios+offset, obj->buffer.pointer, obj->buffer.length);
-	len = obj->buffer.length;
+	if (!obj || obj->type != ACPI_TYPE_BUFFER) {
+		DRM_ERROR("ATRM returned an invalid object\n");
+		kfree(buffer.pointer);
+		return -EINVAL;
+	}
+
+	len = min_t(size_t, obj->buffer.length, len);
+	memcpy(bios+offset, obj->buffer.pointer, len);
 	kfree(buffer.pointer);
 	return len;
 }
-- 
2.53.0



