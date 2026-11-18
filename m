Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017845;
	b=DsMdbdcdwrZSATu13jgyWxDY8raoAeGaJOWfHxa52L3EhS3FQJXnpOusIk4hYlOIMAv8
	 GAjoBHfWxMAEnSnyFTK9QcWPwTLqJl+QK02gdoqa0vnLqYfq/bkQPvae87XDQiD3mfcDc
	 bDLEmmLyOalvLuHCDeucMO/juP+xqpaec5rMWWTy87FQwFBWU+WZj9FlNuOiQAi4dtoro
	 vk+NGF5dQ108FV9ziPFKk9jZRLKXbR3Gn9y+M157GLzHmD7ADj2JlXlNBXXmuxLJpp0wH
	 cpTTGxM68XF/NuKjA3aBwBXzreFkz9sUVi4aC2H08my+WftsM1yFsymU2g0PtoxgYsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017845;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SM2mQ4V51C7oP1sfc8udaWMgP89ef70olpsFakQhHH0=;
	b=tH0AZX5IMO2FHcmDwVISVQ16v8Ljw3yOIkgWZy69g8dYmfNe7cGNxzTuBNwSk2f8/Ie0
	 2kfIte/wbijmNwTgUx2X83a1W316kR0tJbEt0NeIZXLYug0KWzvNPH5qNchMI+ndBF+ue
	 CnJXSCR4kZ6l6PS28zCbJC3lll9TejgkausLSG1M7OwrS/nswOg16qCo9vnqpv8GRyBoc
	 Y9Lm9Ld9EIXnfDD+fYfO+mzIZrsBixw9GNM8mK3kfjkzBymLLmRWp3pUdADz0iakIcByk
	 eYYhspya5BGY4nwGSYCsKkc+E0MjzCvMdB9mUfDiUWjk3MAnxqAZsFpOw7fMw4iJIag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dT3iwYXQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBB6606A325;
	Wed, 18 Nov 2026 16:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dT3iwYXQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485C31F000C4;
	Wed, 18 Nov 2026 16:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017844;
	bh=SM2mQ4V51C7oP1sfc8udaWMgP89ef70olpsFakQhHH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dT3iwYXQwglS3HDEB8onE/uBxta8IuWpwY8qi1L5hjzIX1zVm3IQxs0Vx/CAfGqc2
	 c9yrFq42pgF/yMCs4frkpbkbwukU5RVyO3sge5FRuGykkxmGKh1mR26qcDsPSvmnPF
	 nfaLY/69ah7RNoc09a/XrPYF55F714dPKsdk6XVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1028/2651] clk: ti: adpll: unregister OF clock provider on remove
Date: Wed, 18 Nov 2026 15:37:48 +0100
Message-ID: <20261118150324.970687619@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 4c943ddfc24340f1b899762b1ff35c38306b7a35 ]

ti_adpll_probe() registers the driver's onecell clock provider with
of_clk_add_provider().  The remove path only frees the clock resources,
leaving the provider registered after the backing data has been torn
down.

Unregister the OF clock provider before freeing the ADPLL resources so
the provider no longer points at released driver data after device
removal.

Fixes: 21330497f303 ("clk: ti: Add support for dm814x ADPLL")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/adpll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/ti/adpll.c b/drivers/clk/ti/adpll.c
index 8885d28face50..0d729c9980a55 100644
--- a/drivers/clk/ti/adpll.c
+++ b/drivers/clk/ti/adpll.c
@@ -925,6 +925,7 @@ static void ti_adpll_remove(struct platform_device *pdev)
 {
 	struct ti_adpll_data *d = dev_get_drvdata(&pdev->dev);
 
+	of_clk_del_provider(d->np);
 	ti_adpll_free_resources(d);
 }
 
-- 
2.53.0



