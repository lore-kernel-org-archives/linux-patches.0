Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8AF1D416E;
	Wed,  6 Nov 2024 12:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895169; cv=none; b=O4x/JFNU/WaBA8GigLBEtjZVk5cFeMm6k3XIAjIuaMfeujxa7EHEv5TEPEzMdD7HFDLS4W1MP1DgSgWnqugbLjJuhnPyYRcnsRTjG/XLc+kudt+12LaMoMk2t573lu0yOIkJ0N2RpM4BfPZ47btbtno1QCM0kjQ9pS7ZH45ykOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895169; c=relaxed/simple;
	bh=VW2ZQorq2eA15jo/UHxOnnSRK7YNBseN4QUNsRhssl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRUZEcZ6Qt4oCVdXhP9M1o4xtLbLi/OGFEF92V+FUm3fAyKcPKq2Qy1f7ynPKXfUqAt0H83HkEPFD0E5Cw47I/SQZSZBXKtG1oVz+aK9FWX0jQLjXmDkKP6TIr3d9bp/0Ur87t593CCD4foOcmlKAPZVjgQcEsCMjj7cV8jAxC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bgm3/b2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bgm3/b2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1309BC4CECD;
	Wed,  6 Nov 2024 12:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895169;
	bh=VW2ZQorq2eA15jo/UHxOnnSRK7YNBseN4QUNsRhssl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bgm3/b2FMFdwwjy/KQ5SkCJOuRrupmzPwEPadVYc/mo1UOj0U8KHeWonqgX8Bkl6D
	 9/xfULJ0PHPJdGtwIAsmsPVD/gwEGTRwguGpcha6b+/gEyYn4I/qPGVSK0haGIjLef
	 s58q+p5ryiNE3CT0v7lO7uHF281D4PPd3KdJ0Mrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 127/350] pps: remove usage of the deprecated ida_simple_xx() API
Date: Wed,  6 Nov 2024 13:00:55 +0100
Message-ID: <20241106120324.044762943@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 4db824f88d009..de49ae85adbeb 100644
--- a/drivers/pps/clients/pps_parport.c
+++ b/drivers/pps/clients/pps_parport.c
@@ -158,7 +158,7 @@ static void parport_attach(struct parport *port)
 		return;
 	}
 
-	index = ida_simple_get(&pps_client_index, 0, 0, GFP_KERNEL);
+	index = ida_alloc(&pps_client_index, GFP_KERNEL);
 	memset(&pps_client_cb, 0, sizeof(pps_client_cb));
 	pps_client_cb.private = device;
 	pps_client_cb.irq_func = parport_irq;
@@ -198,7 +198,7 @@ static void parport_attach(struct parport *port)
 err_unregister_dev:
 	parport_unregister_device(device->pardev);
 err_free:
-	ida_simple_remove(&pps_client_index, index);
+	ida_free(&pps_client_index, index);
 	kfree(device);
 }
 
@@ -218,7 +218,7 @@ static void parport_detach(struct parport *port)
 	pps_unregister_source(device->pps);
 	parport_release(pardev);
 	parport_unregister_device(pardev);
-	ida_simple_remove(&pps_client_index, device->index);
+	ida_free(&pps_client_index, device->index);
 	kfree(device);
 }
 
-- 
2.43.0



