Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7125B1E0DF0;
	Wed,  6 Nov 2024 13:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898227; cv=none; b=BWHIHsSTJsnms6W0VXDyD9oSVuCxzAagx1W+n8RYU4TuJKqUhHzi1zLT0COyGZMURVJQtyI+jdDVASYojb8EYAIlytkiDSJXl7md7y1O/0xNgDFY6H2A2ZIXL/N1ls7LjItri2SeQ9xbqRryn1+3SO8IzRnvdDyq7xhHSFN0/II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898227; c=relaxed/simple;
	bh=gXWHiTPPTibq+5oS2VzVu7h850hQr2Mt9JtulyM/L3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSj1RQvwG29H9ey0EemokYxqtEzHnK7k66SrmMMh8k7FqLm5eYxCUsmxftlc+ZkcZrEwHDCA0Md3g3rVJQdZAHfqZdFVrOI6Gvjbl6MhAI3lhm4ddULaKppUZETZb5Us5Eh1cZqxfh2FW8iYMvWdgGXX40Kqra2nRbK/uF+vLRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEPK5IYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEPK5IYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E478FC4CECD;
	Wed,  6 Nov 2024 13:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898227;
	bh=gXWHiTPPTibq+5oS2VzVu7h850hQr2Mt9JtulyM/L3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEPK5IYcqQ4TfOSr356bRuBQt4q9jULxhDitY7tfMAyb/kqr84AxCHktatcXXf2jv
	 GJ4MXr4a+UBWboycwaa9TOPzCtZX/SdOIdI/2vOARaLShm3Vnn86WROck9SjDre8o1
	 OpKkr8JkZrgnP+sqU5BrPtOiWVy/7Z37aFRHHB9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 167/462] pps: remove usage of the deprecated ida_simple_xx() API
Date: Wed,  6 Nov 2024 13:01:00 +0100
Message-ID: <20241106120335.646412984@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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



