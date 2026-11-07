Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061568;
	b=SU+EXBdzLLQoE0ageSTc4Of5lrE42XMa7z5Qdrs0HrmtqBwLWBs6yWskzIPV6LN2sZjd
	 1iG/KnrlNzqacFYjX0IngHMB3SXMM6AbXL6bORKweiwNYTXXg9enI3R5YXBnNvfxcggs9
	 6P3MR6jiVTtX3MU2tUD2XBz79Hdt2cREOmc+NecxOSYVSO/1EIbUG5GkKHu1PCf9359TV
	 ZFjrdddOjxZFq+PakISJDXpt2RBlw0eeOvK6+oHurt+Dl1P9OHrDQNM5jczNOG59UpD4Y
	 wlu5yJNzfg2YBldTgq9dcwdB0BD+TPHon1zPU+N8+Xu5Ae2QuRAQITm7qwdzALm2iWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061568;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZS8V6AilgZT+Unp7H3hx4fyAqYj2fKOL9Fh5yIEahM4=;
	b=SJtjARbGnds1hpb3HvYklwWd6LweaX9eLr9et31bhfOKRusMnaC2LzARUcPKldmwpkKo
	 fsCpQgzoUTWIz+mdmzAufbMoOKfSSr0ZBhFusw73HTIiRyF4iKLP/kX0gkk8Vm76y9lI2
	 /22Wx850FQDgjOuKe5fZbSe0x6D7WQCIsG8+z5P4YUv6yshOUA2nbvSKGvTWEgFn0A7VI
	 fT8y9RvIQ4BvkF5wJDDt1Zjs8Zpn+NQm3C/xMzkO7m3j8EEj5cp8k1INEUgKFcsmqUIWa
	 uWlR0BtBSIrU8uLQ30BwApEvy30iZgfdZqQ5IbA9S74b6HJXxuktZe1bktmXR3iJ1zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+NAmX+G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E854606A32C;
	Sat,  7 Nov 2026 14:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g+NAmX+G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26C01F0089F;
	Sat,  7 Nov 2026 14:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061567;
	bh=ZS8V6AilgZT+Unp7H3hx4fyAqYj2fKOL9Fh5yIEahM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g+NAmX+GavAyOBXNrIYk1LjaMHdUK1VTUGwi9RxKvLmaIklqQx7fR60bbQ+Yl2jFz
	 iG13VDlNv90xFfrwKyB0OOELmwT4mN5DIAW14t6EkKSOqNZGeh0YDELMULsUWjNYkE
	 Af7rbr0v6gIWkWredi9hmtZIFCUqCSOtHvEhshxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Eugen Hristev <ehristev@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0647/1536] media: microchip-csi2dc: fix async notifier leak on probe error path
Date: Sat,  7 Nov 2026 08:44:23 -0500
Message-ID: <20261107135015.698571868@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit c7528789244ce7329ca883170fb9315d739ae985 upstream.

csi2dc_of_parse() ends up calling csi2dc_prepare_notifier(), which
registers the V4L2 async notifier with v4l2_async_nf_register(). The
probe error label csi2dc_probe_cleanup_notifier is reached after
csi2dc_of_parse() has already succeeded (e.g. when media entity init,
csi2dc_power() or v4l2_async_register_subdev() fail), but it calls only
v4l2_async_nf_cleanup() and never v4l2_async_nf_unregister().

The notifier therefore stays chained in the global notifier_list while
the enclosing struct csi2dc_device is freed, leading to list corruption
and a use-after-free when the list is next walked.

Unregister the notifier before cleaning it up on the error path,
matching the teardown already done in csi2dc_remove().

Fixes: 2de0b3c0f678 ("media: atmel: introduce microchip csi2dc driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/microchip/microchip-csi2dc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/microchip/microchip-csi2dc.c
+++ b/drivers/media/platform/microchip/microchip-csi2dc.c
@@ -736,6 +736,7 @@ static int csi2dc_probe(struct platform_
 	return 0;
 
 csi2dc_probe_cleanup_notifier:
+	v4l2_async_nf_unregister(&csi2dc->notifier);
 	v4l2_async_nf_cleanup(&csi2dc->notifier);
 csi2dc_probe_cleanup_entity:
 	media_entity_cleanup(&csi2dc->csi2dc_sd.entity);


