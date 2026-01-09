Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B422359703;
	Fri,  9 Jan 2026 11:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959936; cv=none; b=fn/vhM0TyMLKHNOxUdpiUywh3EcjT/KKHCieyicO/n2SKKKqHofhZ6yyHIeTzxh7KOmoC86grwsNzulY9dRn7s4jvwO3tCvn+oWluxOfwr3FMaozX9rd1AYIU94GVKyiqcH8WtyHsggcKpbpXwtyLk6bM9ylK05GnYbBTUIPcnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959936; c=relaxed/simple;
	bh=iTRsOwhOSAsMdDAQWBF15WODjZhdwNOe5gO5d5+nZys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q7tBEtCr9NCk1vNQAhkBXsf7OD9Ayq0PCuzA7ew+A8fvjcMssTb5+rAnh6kLen4lIsZcEQDLi0hl7k7DazD/UcN1g6vCdjaHqY7aozuyQKE3hpvS0sfqim8WXkl0myyVU61V/eg9FzBV8BZ/1zOhsUiHVhbSMtMQyfGzNXVTQM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUjqlKoN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUjqlKoN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA13EC4CEF1;
	Fri,  9 Jan 2026 11:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959936;
	bh=iTRsOwhOSAsMdDAQWBF15WODjZhdwNOe5gO5d5+nZys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUjqlKoNubxpleCwWKm3k+FAmpYkA0HAl+C1edZ42ZufZhuAu5MdVwk1hELSVf3Y6
	 z8WQsMgAP2S0EoK1Qi1HqFESHvpV1wIwFz8VaX6NHMM6787LTBeec74wl96YbqAzpq
	 l45vhi56Cj2CC3eXBUtyZq8+oqEgN7S6PSqw6sZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/737] virtio: fix virtqueue_set_affinity() docs
Date: Fri,  9 Jan 2026 12:36:07 +0100
Message-ID: <20260109112142.576911619@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 43236d8bbafff94b423afecc4a692dd90602d426 ]

Rewrite the comment for better grammar and clarity.

Fixes: 75a0a52be3c2 ("virtio: introduce an API to set affinity for a virtqueue")
Message-Id: <e317e91bd43b070e5eaec0ebbe60c5749d02e2dd.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index f106d3177476b..7528255068fd8 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -310,7 +310,7 @@ const char *virtio_bus_name(struct virtio_device *vdev)
  * @vq: the virtqueue
  * @cpu_mask: the cpu mask
  *
- * Pay attention the function are best-effort: the affinity hint may not be set
+ * Note that this function is best-effort: the affinity hint may not be set
  * due to config support, irq type and sharing.
  *
  */
-- 
2.51.0



