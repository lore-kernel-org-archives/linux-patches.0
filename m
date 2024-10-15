Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5861AF0AD;
	Tue, 15 Oct 2024 13:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997685; cv=none; b=Dp7JKXOkdv1OjjGIx1HTkNWAvqpPLSuPdQs5Pe3edwDCUOikhqBdf0XIGW+nX0tH0tbL1YptZXfk2mExSqT3z5mLuzxx5pnS7s5N6Gj86oq0SUWwCgvH8jvUs2diN+hSGyunWojLR7pyOeQmo05s+Oj+N/o1PE42+4nlGKHBydk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997685; c=relaxed/simple;
	bh=NkN4m4FtWl8GIP4Jlq3mbilUnOQSvjMO7gJSveIt/cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1tqZZRsJ1Cq4gLmFREPa2oBNQYYBOgfPBrfED0ADCVfa/Lm0Hr0hrnO3HsFoFg21VnnovKM/OSxmeWPLRFl1lcNeqdmhy6b1JCpv379EqyTWFnzjUQmHMB1lyMolqumIQMGsuWNY40w3ZpS8wlTaGvmbv0JRlYZBDWgKfKI9HI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRxr35ic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRxr35ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1C2C4CEC6;
	Tue, 15 Oct 2024 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997685;
	bh=NkN4m4FtWl8GIP4Jlq3mbilUnOQSvjMO7gJSveIt/cM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRxr35icV//0B0W/g9mu98gOBZZ2lpnIZA4I8Ryf6b+olXDi9bDrnW0gh0dUGCXQM
	 a0Kf0KIkok93Qm7gijdMikbwb1lkAZDALlghicV/qu4g6T5BwAmd2Up2lpaMO3e7Yx
	 czDSIwjQjjRBNgGzFUfAXGWAbqh5J/q8izinNuS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/518] pps: remove usage of the deprecated ida_simple_xx() API
Date: Tue, 15 Oct 2024 14:42:39 +0200
Message-ID: <20241015123926.832619567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 55dbc5b5174d0e7d1fa397d05aa4cb145e8b887e ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

This is less verbose.

Link: https://lkml.kernel.org/r/9f681747d446b874952a892491387d79ffe565a9.1713089394.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 62c5a01a5711 ("pps: add an error check in parport_attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps_parport.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pps/clients/pps_parport.c b/drivers/pps/clients/pps_parport.c
index 7a41fb7b0decf..4bb3678c7e451 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -144,7 +144,7 @@ static void parport_attach(struct parport *port)
 		return;
 	}
 
-	index = ida_simple_get(&pps_client_index, 0, 0, GFP_KERNEL);
+	index = ida_alloc(&pps_client_index, GFP_KERNEL);
 	memset(&pps_client_cb, 0, sizeof(pps_client_cb));
 	pps_client_cb.private = device;
 	pps_client_cb.irq_func = parport_irq;
@@ -184,7 +184,7 @@ static void parport_attach(struct parport *port)
 err_unregister_dev:
 	parport_unregister_device(device->pardev);
 err_free:
-	ida_simple_remove(&pps_client_index, index);
+	ida_free(&pps_client_index, index);
 	kfree(device);
 }
 
@@ -204,7 +204,7 @@ static void parport_detach(struct parport *port)
 	pps_unregister_source(device->pps);
 	parport_release(pardev);
 	parport_unregister_device(pardev);
-	ida_simple_remove(&pps_client_index, device->index);
+	ida_free(&pps_client_index, device->index);
 	kfree(device);
 }
 
-- 
2.43.0



