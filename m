Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE563559D4;
	Tue, 16 Dec 2025 11:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886256; cv=none; b=HT40gFZnG/ZuzZEVi94Axg/40EIUiD7Q3qlJwj6jbQOYq2c4yMsdmOFY9V/ZN+MdeIOtihEB7kxse5IqEcsJEwBkGer4U+keoPc3nEHxAawuIu819ZHwqx6LMhNVBppxOMJNwcDyLUxqRXQM+7fvaPA01aCtrBHcR8EfF/gydxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886256; c=relaxed/simple;
	bh=DpHKzzP+8LqyeI09Eu8YRKr0KgKm41U3wPDvovuKma4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YX/VnwKkNYOrsNUWWAjZ+wII8L5q0ivF4C8qtQ030PE88E185xUaNgjaD+a5Hpd71rtLMQtvnIdMRgfbhZkAgGWwm4XJNmu+zZOXrr5S3/A36i/0FetrXfiXw961vQaC6K+y+anO62q89849Y7qPJq082g5B5gyM6D4et7pBcWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGp9ijon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGp9ijon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7686AC16AAE;
	Tue, 16 Dec 2025 11:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886255;
	bh=DpHKzzP+8LqyeI09Eu8YRKr0KgKm41U3wPDvovuKma4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGp9ijonKwBuqTG+A3F+Z8Agrb0lV72da8KQnJ80mqfkRu9TaUZMDiQTMkalUMvM5
	 zBz4maf9umsAFKyvn9HsF/j69lZKaTWMV5ErZvkQbN9y9nthnmmrDXMWOCm34W1wb7
	 zTv4K8RPStsFe/5m2gxt8xQnLMORh5BU6eqK43ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 382/507] vdpa/pds: use %pe for ERR_PTR() in event handler registration
Date: Tue, 16 Dec 2025 12:13:43 +0100
Message-ID: <20251216111359.299211034@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 731ca4a4cc52fd5c5ae309edcfd2d7e54ece3321 ]

Use %pe instead of %ps when printing ERR_PTR() values. %ps is intended
for string pointers, while %pe correctly prints symbolic error names
for error pointers returned via ERR_PTR().
This shows the returned error value more clearly.

Fixes: 67f27b8b3a34 ("pds_vdpa: subscribe to the pds_core events")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20251018174705.1511982-1-alok.a.tiwari@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/pds/vdpa_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index 301d95e085960..a1eff7441450c 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -51,7 +51,7 @@ static int pds_vdpa_register_event_handler(struct pds_vdpa_device *pdsv)
 		err = pdsc_register_notify(nb);
 		if (err) {
 			nb->notifier_call = NULL;
-			dev_err(dev, "failed to register pds event handler: %ps\n",
+			dev_err(dev, "failed to register pds event handler: %pe\n",
 				ERR_PTR(err));
 			return -EINVAL;
 		}
-- 
2.51.0



