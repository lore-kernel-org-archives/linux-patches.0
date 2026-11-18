Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042827;
	b=tLLWU6URyQmPoNCrPiPqpXPX+qMzzhliXl4Fj21iqc1Ch/vYndYdJghCqZWNJ2NrZCk5
	 DckORewBvKe7Sz+lVqt76NuynDqTjuixPONtAcEMZlxjpkSywvChoUVyXJ1Q5VD4/GTvd
	 JSnpwRGVTHcsiQ+jlMzFKdsIfhW/p5blRbdNcbJNKDZc8i+Bw76FM7f9OH6hWm1Pk4tet
	 0+HepsghOAJbp6QH5y0aBWcGTT3pOMGtMfR6Iei2rkxMJLb2dC9MYJ11vqTb/yO3dA5aW
	 boTDhqtg8KgXALXjs1dxRdeuICXMvJo5LPpyFRKLv3d+jupkvzM0QfZDgU88c/BLYYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xNrl1aeGP8FMrh1bIVLOwWrMwns4qppQJEDAAn+s6oI=;
	b=sesRTmSXqUc1OHp5WYkpGTihIFtMxJwhJRDSEtFBSTSjKxXUJ+E8G6OaLKjRHFC8nXzY
	 I9XmB7IOEkdy7ehjvFeCxLIQ/0WGKdjKRZtNrZzfQGpG9hfkwB5WFt+kiZ9LKenJZBWgg
	 g308s1nsFLFoGtENptbNQYOkMzEq4crYdV372boqdTQ3r99Z/Pc4AcmJTc+SSmoXCiwHl
	 F3HoU+UAGG/ws6/eDMJqvXJcShe8MAG3x75eyawyYb3gC+Wsja/uemY+9dpDdYs2DofFw
	 CF+mUL0KTyGo46bT3TGnl7lM4oVI+O6VLwXVUYs6TBE/Bf46KQwPKtnLzqJcOW2sUtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YWh2i0G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC09606A334;
	Wed, 18 Nov 2026 23:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1YWh2i0G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4211F000C5;
	Wed, 18 Nov 2026 23:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042827;
	bh=xNrl1aeGP8FMrh1bIVLOwWrMwns4qppQJEDAAn+s6oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YWh2i0GpBx3UPMoK0k9if28GsmJxsClXteKrhW7tfRCQEv0E/pxWItaaRoLcp6OT
	 BSt7hb9fXNaAIcBnd+pXKnGnLw+K/rb7r+YPRsWC5ROd56IJ7wsvirPF+j0/2jaKMO
	 eO3Je1N/bCUP5WtNPvdMdK3CCsFaf0n9Lgca5vBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 3309/3318] nvmet: do not return reserved for empty TSAS values
Date: Wed, 18 Nov 2026 16:05:31 +0100
Message-ID: <20261118150458.857156073@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

commit f31e85a4d7c6ac4a3e014129c9cdc31592ea29f3 upstream.

The 'TSAS' value is only defined for TCP and RDMA, but returning
'reserved' for undefined values tricked nvmetcli to try to write
'reserved' when restoring from a config file. This caused an error
and the configuration would not be applied.

Fixes: 3f123494db72 ("nvmet: make TCP sectype settable via configfs")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -378,7 +378,7 @@ static ssize_t nvmet_addr_tsas_show(stru
 				return sprintf(page, "%s\n", nvmet_addr_tsas_rdma[i].name);
 		}
 	}
-	return sprintf(page, "reserved\n");
+	return sprintf(page, "\n");
 }
 
 static ssize_t nvmet_addr_tsas_store(struct config_item *item,


