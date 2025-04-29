Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950D1253952;
	Tue, 29 Apr 2025 17:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949308; cv=none; b=fUvfW2d8/jqY5ANQxGcQ1OpyKp0SH/yOxx4IAMgEyRWYgsjX9gN7lVAnPz2hCIICG0YFCa6khOAcOrJfBQ8kLoBjy7XaYCKna1kMPR4HzyuPTo+EjwhnwTsI5lja6q1HU4giG/a5c6MzPJ/6Wbxd0kisakzVs8tAvi89xvwSxFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949308; c=relaxed/simple;
	bh=rE7atgZirpw2iZfb21qZ7JRTAci5Ii4y8A6XgmY8bhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BWkkGtaWStoucO62wt6nHFl1k3s7XpJU2poAEad4iNFJSkgSRIMOznucYydwsjAkYt6/KcY2RPXrFv4tRwkSwLu0DVOnbCE8KQbgViU2h4wY9O1SWzxsaq718aiy3fhcgOA00AeocdspcQ580yjS+IuFGJ/VwcIAGD3eQ9GLI7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KXlkz+ed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KXlkz+ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03369C4CEE3;
	Tue, 29 Apr 2025 17:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949308;
	bh=rE7atgZirpw2iZfb21qZ7JRTAci5Ii4y8A6XgmY8bhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KXlkz+edgFuYoGI35GWG0h2BNKCWoFEJiUkLcpQcr2wOP7KJpSuLbBbXj7U+uFT2y
	 gq9wPa7tGF6s0R32RqCYJbY7tGRMP/ZoHJHir8eMb5lnnuPijUVUu171FhhbN9P9mp
	 4I0weDOuCzsU1ei+8AMGeDHfRHrCTDemFWJYZkh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Feng Liu <Feng.Liu3@windriver.com>,
	He Zhe <Zhe.He@windriver.com>
Subject: [PATCH 5.15 250/373] pmdomain: ti: Add a null pointer check to the omap_prm_domain_init
Date: Tue, 29 Apr 2025 18:42:07 +0200
Message-ID: <20250429161133.407582195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

commit 5d7f58ee08434a33340f75ac7ac5071eea9673b3 upstream.

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20240118054257.200814-1-chentao@kylinos.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[Minor context change fixed]
Signed-off-by: Feng Liu <Feng.Liu3@windriver.com>
Signed-off-by: He Zhe <Zhe.He@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/ti/omap_prm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/soc/ti/omap_prm.c
+++ b/drivers/soc/ti/omap_prm.c
@@ -696,6 +696,8 @@ static int omap_prm_domain_init(struct d
 	data = prm->data;
 	name = devm_kasprintf(dev, GFP_KERNEL, "prm_%s",
 			      data->name);
+	if (!name)
+		return -ENOMEM;
 
 	prmd->dev = dev;
 	prmd->prm = prm;


