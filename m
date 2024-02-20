Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1820B2DF9F;
	Tue, 20 Feb 2024 21:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465318; cv=none; b=dkcksPrYFAqbt6S1zFYEyDgwNAVBHDWtI+0IFB4mg9iUiVvo1cAFuSTAr8jxGBkORV4iZkZMAly0Y1CiZOD3LI5O2zCnir/TSl6DiL3pFTq5CYYg2wK1s6KwGJ/dEdFDvf0KRQvvvATof9mLYzPGGZiMqiVXejTTTco/AHrFY8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465318; c=relaxed/simple;
	bh=Nz6/A8YWE0kO0hBija72F22MVz66MZ/NdEYdGt2NknU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3581vV7NuyLT7K544210IHz1obxGMUtu3gCyQqK9stsTxBnUbgBkK3MMorZO9ZbnF++jtkFh3iSn4rN6Q9StjoiLEJNUCcz/xlsumsj9XZWwCQB5jg30gFNh3zC5Tmd1IhfOu3cK/MHdKckJgba1CZXjpnB/x1Y1JRtMpcm6PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ixggaPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ixggaPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B3BC433F1;
	Tue, 20 Feb 2024 21:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465318;
	bh=Nz6/A8YWE0kO0hBija72F22MVz66MZ/NdEYdGt2NknU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ixggaPVAZWB6HHRpBo926NryZqcWwKB5oJRa1zc3Bx9oyUpnQHBCXkSaQc7N+4hi
	 hIBLarpgoLOuigi7eQ0JxE93yyfLyzW024Ghktj0xei+DWiiTTMBeWKDHAzEYeSDr1
	 A6DAmoiuJFdpNJHDxgqX1syy8F+hIja58I141Av0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Danilo Krummrich <dakr@redhat.com>
Subject: [PATCH 6.7 288/309] nouveau/gsp: use correct size for registry rpc.
Date: Tue, 20 Feb 2024 21:57:27 +0100
Message-ID: <20240220205642.122348590@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 61712c94782ce105253ee1939cda0c5c025b2c0c upstream.

Timur pointed this out before, and it just slipped my mind,
but this might help some things work better, around pcie power
management.

Cc: <stable@vger.kernel.org> # v6.7
Fixes: 8d55b0a940bb ("nouveau/gsp: add some basic registry entries.")
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Danilo Krummrich <dakr@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240130032643.2498315-1-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -1111,7 +1111,6 @@ r535_gsp_rpc_set_registry(struct nvkm_gs
 	if (IS_ERR(rpc))
 		return PTR_ERR(rpc);
 
-	rpc->size = sizeof(*rpc);
 	rpc->numEntries = NV_GSP_REG_NUM_ENTRIES;
 
 	str_offset = offsetof(typeof(*rpc), entries[NV_GSP_REG_NUM_ENTRIES]);
@@ -1127,6 +1126,7 @@ r535_gsp_rpc_set_registry(struct nvkm_gs
 		strings += name_len;
 		str_offset += name_len;
 	}
+	rpc->size = str_offset;
 
 	return nvkm_gsp_rpc_wr(gsp, rpc, false);
 }


