Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E6427713;
	Tue,  9 Jul 2024 11:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524350; cv=none; b=ZUVth1OXBXjWP+mu3dZm4MyUygvcvk3fuhc5NcfRMu9LLLWv7GB+extahkS5XXGISbzMBHs9COMn2stx8NlYP8LPzthDmijw4ryM5R0XeyfOcpbutUfqP7dK4tgLPfeOq84WbVo2Lz3CtAb1fcnJZrb+12l24wP86HvCxJhE37U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524350; c=relaxed/simple;
	bh=zNAvQXQFWHnto2YlYEftJKHr8R/seao0PBsZBfN9CZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MrWIEbmsDlyViUXHCqws9dRe1eR1T9jQGRZlqW7dYTCgznvH9sRBYY1wqsOHrZW50JEknJv9gQGy54JWqCNivKpcaUn2ClMj33/b/OvTBXMcLgAn04C/ozO8913higHh2LwxButLDF74SOKi6UOp9N8s9CJlEY0yfyN0iGd8n2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1emFah5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1emFah5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDA2C3277B;
	Tue,  9 Jul 2024 11:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524350;
	bh=zNAvQXQFWHnto2YlYEftJKHr8R/seao0PBsZBfN9CZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1emFah5OEmroKhukj2wU8gnDMEM5HFe9LAz49vgT2aoXc1DpNJgrbdPiNNRBGkE2X
	 aP8PbHQf6eCs0yNfmz/wRRXYpM4jJga5Amhz88hV73mmouHJgNZGGTSwt6Y3oarSPt
	 P8hsEkbSZhh5yaZ62ZxUmyCSgAQ3M/QQftvC16gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.9 152/197] drm/amdgpu/atomfirmware: silence UBSAN warning
Date: Tue,  9 Jul 2024 13:10:06 +0200
Message-ID: <20240709110714.833899232@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit d0417264437a8fa05f894cabba5a26715b32d78e upstream.

This is a variable sized array.

Link: https://lists.freedesktop.org/archives/amd-gfx/2024-June/110420.html
Tested-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/include/atomfirmware.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/include/atomfirmware.h
+++ b/drivers/gpu/drm/amd/include/atomfirmware.h
@@ -734,7 +734,7 @@ struct atom_gpio_pin_lut_v2_1
 {
   struct  atom_common_table_header  table_header;
   /*the real number of this included in the structure is calcualted by using the (whole structure size - the header size)/size of atom_gpio_pin_lut  */
-  struct  atom_gpio_pin_assignment  gpio_pin[8];
+  struct  atom_gpio_pin_assignment  gpio_pin[];
 };
 
 


