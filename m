Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CBE183CC3;
	Tue, 30 Jul 2024 16:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355989; cv=none; b=Y3CAp+XiYLCF3/BrQAK6Q6KPqxjGWJc5GNcG0Xq4WkgKIzf9Lz0qyjII+WZgUW0Gik8ajATOLspQHOIytezzRJLH9xX41EkI2NRlSGCE0NMRtqRvVgzM+ilJt53y57CSd1OxMhpjE2dNbB0Tsv0fyYwMaDLRp2oDxS1hGL8PElE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355989; c=relaxed/simple;
	bh=an2oQn4u7qFOblw/3ZC3b2PsKwpvxx0EqzdugzoV8zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7snYz5471RgeOBPlMbPxka/Iw9a6eQBl0WPibIYx8WX9WAdcd4/72wVTBunIV+3FrXxgyvUWz4tSljtOoRf4k2HUAbSkykJQ813IthRRoBuXK4DntRDplEMuTe32qChkbf+dOyq9jOMUQ4i0gEWmpOPqT2GakfRYYw7uANoML8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQSfVuJX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQSfVuJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2A0C4AF0C;
	Tue, 30 Jul 2024 16:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355989;
	bh=an2oQn4u7qFOblw/3ZC3b2PsKwpvxx0EqzdugzoV8zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQSfVuJXyZXb6I8leUki0HMtGnz0FroSYGaB8FyU0VU/k9T9mbUie5Epa94xqkGZH
	 zfUAQqasDtrFu3Wm5JIVRnPjd2VacWjirKVXea4eu4qrIuh6TYz1f6KTMFXRisi83G
	 hsog2g+S76Ero9X2xvMT3bcXLuhlxH5HGEgQtEac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@toblux.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/568] m68k: cmpxchg: Fix return value for default case in __arch_xchg()
Date: Tue, 30 Jul 2024 17:43:31 +0200
Message-ID: <20240730151643.940255438@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@toblux.com>

[ Upstream commit 21b9e722ad28c19c2bc83f18f540b3dbd89bf762 ]

The return value of __invalid_xchg_size() is assigned to tmp instead of
the return variable x. Assign it to x instead.

Fixes: 2501cf768e4009a0 ("m68k: Fix xchg/cmpxchg to fail to link if given an inappropriate pointer")
Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/20240702034116.140234-2-thorsten.blum@toblux.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/cmpxchg.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/cmpxchg.h b/arch/m68k/include/asm/cmpxchg.h
index d7f3de9c5d6f7..4ba14f3535fcb 100644
--- a/arch/m68k/include/asm/cmpxchg.h
+++ b/arch/m68k/include/asm/cmpxchg.h
@@ -32,7 +32,7 @@ static inline unsigned long __arch_xchg(unsigned long x, volatile void * ptr, in
 		x = tmp;
 		break;
 	default:
-		tmp = __invalid_xchg_size(x, ptr, size);
+		x = __invalid_xchg_size(x, ptr, size);
 		break;
 	}
 
-- 
2.43.0



