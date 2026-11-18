Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033522;
	b=V0VQ+Ua7X4XlLurYMz5Ae2GRlMqsdfVn9xA/mayNVP1c/GlnrXhPSJLZiAT0BgJZruf9
	 JqjriCdd6RJk5dcwXk7hPdPxOA0YhtcpypOMUyStqCHO/7uYIwkn/5a1DlOD64uXaf8sW
	 OoQBzCKYh4UZraMEDjWNwZkDjYy6i2h4cGU2I3AFtx4wWY+PRt5lMmRfxAPqzh/mfeFrQ
	 9bq60ywQ4vjeJvcORkdJBEYMKfMMJmuNjbkBurNkORcm22UcO55YN6JatgFKgsa9BybxG
	 HqF8hq8DET+5Rl8VF4lzuqTk5/Mx9Qe2L8VYJhCMR7Zh9KGMQjyGpN1gVcxUbuzKQKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NvfqfLNH7vrIRiwHswIyEAo0FNaLzhjbJCNqEsuvrXo=;
	b=ArTDz7JEt5wUSAVQUNwFT1cFMlIZs2O6xOGmT5GdJxlJOU+MWULmRxjR5L9noEOXnRDT
	 OA1uE3vsa7Ez62ynl2ecQVi4WKY+F6rop7VaX+Cs8/4zrzp+er6ww60zDlNr3SUuhzTCo
	 s3iQmU2WxXYGpizGIrOXK2sd7A4hBe7+37J+4qv5DJPrXYizF3TXwMiSOTowapffzztxc
	 /yCON0roS9rzgIv9zjGXTfusTRAhffUdNneAXVEgvvtjnQ2TaqfWd6rHvGFlSzv+wjO7V
	 4pVIR3nkK6PYzzL1Y34r3paK1Vd055AlbA0fKwazuwnn5YLBRXmWtIj8wqamMRTbtug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvvdZv1n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320EB606A31C;
	Wed, 18 Nov 2026 20:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DvvdZv1n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F411F000C4;
	Wed, 18 Nov 2026 20:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033521;
	bh=NvfqfLNH7vrIRiwHswIyEAo0FNaLzhjbJCNqEsuvrXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DvvdZv1ntoPwougGDLAaRmHNe4X1vsa6GP6tM2XcOKss/SnYhzMMEALn84sWJ4YP5
	 Nv9YRAURmFuYFIRQNwRoqJNfc+INl4KDYMVrsNffCKcuGl91CeV63ezGp5pjEmj2pF
	 FeBvze0ofN0oc8vJDUzthxu7FqkMumJ3bDDnAlqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0044/3318] drm/amdgpu: Add checks to vbios fetch through ATRM
Date: Wed, 18 Nov 2026 15:11:06 +0100
Message-ID: <20261118150315.200161217@linuxfoundation.org>
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
index 1564cc68fab8e..cf38417b664a7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c
@@ -278,8 +278,14 @@ static int amdgpu_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
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



