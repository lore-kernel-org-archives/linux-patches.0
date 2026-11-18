Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018107;
	b=aBLYb+8YPibwdxErEKABBW9QTlsdYKts2hPs/LMV8IgB2bEF8wlcYXE9miq5xDMYD3o4
	 ap7qii78rL8/sb6XH7rx1aeKfybzCq5DwcfDVdllk68+Hq1hju/iIj5TzdrpxBYvgqVrp
	 oV89jMk5ow1/1S7SgutQdmiIjCU8UIToXwnXRtWyvuiAdW7YUpqKTBX4qAOJYjAqrYMmR
	 lRpviTRSBB8WiaulZoe9mKadrK+N3aTPCGgA8c2v0ZyvfLtOVT+TvvXjBXKfkUoe4UjGv
	 fnEvLkUFIHKjPj4ZgEvXOMrNTVX+PrP1TUwc92s8RFjmqOSBo445wnUbwiBmi6xZLng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IwHdlpKW/Dnbe9XDPT7NjgcGTf1CRbFB1LfxzKXGHcI=;
	b=sGcM8Qo4xlzx/Kkm0GggcxosTy+GVC11LzgNpSCWLxHlwemEFRG9MoOv/YmVnlgxnVbR
	 TKYGKD+PaJTYDMMZXzztr3i8k/nzgsdBMHvICHF+qldsvg9vPRmhVq3/mtbUhsubndW7y
	 tMjQE3OsynYpWLw2NHF1pYESr+HRjF7yMUMjzGjSENnhwRNTLDMEIT2CpzxTC0KBw5Uk1
	 fKC3iXMMKGtKFcYvFN+hwop29qqdIAj0v8wo67pe7Y28cTuyA+DOvTjE4fgFmaLQ9OL9c
	 vqNixbynqbSQGiOmpWTvUFMw7uy+oVB/wES6yEcBItTYL5WATIRoil815wNtzwkHpYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s32oqXlM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C9D0606A320;
	Wed, 18 Nov 2026 16:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s32oqXlM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADCC1F000C4;
	Wed, 18 Nov 2026 16:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018106;
	bh=IwHdlpKW/Dnbe9XDPT7NjgcGTf1CRbFB1LfxzKXGHcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s32oqXlMpPiDlaniAz+MhRKX+8i9erL2nJWQNv/RTeUQreva9h/HWfDOZYrOf/06+
	 WNZkA8G8PhebxyLH80hUYbexzKwiW+qlPzbf+xmybClQL0sC0V8aZaO7kdNJ7WqeIQ
	 1nfabPkayaNNzQj2AtjsbUlJDBK8WV8WkiV/ETI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Yao <yaolu@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1123/2651] drm/amdkfd: drop KFD_QUEUE_TYPE_DIQ note
Date: Wed, 18 Nov 2026 15:39:23 +0100
Message-ID: <20261118150328.437541178@linuxfoundation.org>
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

From: Lu Yao <yaolu@kylinos.cn>

[ Upstream commit 0da420089bdadf26fd02c2144a48faf57736f9fa ]

Commit e1b73b64271d ("amdkfd: remove DIQ support") removed the
KFD_QUEUE_TYPE_DIQ enumerator from enum kfd_queue_type but left its
description behind in the note block.

Fixes: e1b73b64271d ("amdkfd: remove DIQ support")
Signed-off-by: Lu Yao <yaolu@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_priv.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
index f405f476ed182..288731acc928f 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_priv.h
@@ -437,8 +437,6 @@ enum kfd_unmap_queues_filter {
  *
  * @KFD_QUEUE_TYPE_HIQ: HIQ queue type.
  *
- * @KFD_QUEUE_TYPE_DIQ: DIQ queue type.
- *
  * @KFD_QUEUE_TYPE_SDMA_XGMI: Special SDMA queue for XGMI interface.
  *
  * @KFD_QUEUE_TYPE_SDMA_BY_ENG_ID:  SDMA user mode queue with target SDMA engine ID.
-- 
2.53.0



