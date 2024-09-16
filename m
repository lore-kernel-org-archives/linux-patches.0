Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033A3156250;
	Mon, 16 Sep 2024 12:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488024; cv=none; b=lZb6K2ciT61XhNdiKZnXsVF6nSZfTDdbcswKoCnc1keSCdOEcAEeuzqwcQYE0mJXTjRf6o21+nCy6CsMMTFRADuMumHhXsNit4ystGsg2n/RUzkeAaOYDmAMdSr+qrcnh+nDg6m5DbiBLkK0zvLzaRHSnODZlLX5vplH2DhSZoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488024; c=relaxed/simple;
	bh=yMuaUndqguj4++tLkGX/4dBEd2R8kPFQWRC9aExHIW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utitudnADO+SF0HR4Wyiyb5q59J9OrHPs5/1pwXh4ia3YLiGBjuPCG/6g8sNiUy+HT02sZf0LaJSgoE2Q2yE76cvNa3kDXUUaxL5m/V+2XhXj5HVzCqDt1Z3AdfRqbMgmzGm1wZincMc4xXxb/9eXxBqbg3C8jJf/pFbzHgHHO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZpHaYb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZpHaYb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A457CC4CEC4;
	Mon, 16 Sep 2024 12:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488023;
	bh=yMuaUndqguj4++tLkGX/4dBEd2R8kPFQWRC9aExHIW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZpHaYb4mfh44woSEiWWQyfhbOU5ypGQPOJ/7LgvZCwovlJvSeujLuc6PnZtQt/Yi
	 7W51ZE35by7STIcDfj5e88BwSHa64N+o/wBnvYOouQGycUQ/up9vv/ugttZ9nUQj5M
	 CjW07r3630XY3PjOUHFUD8aIexHlWJ5mD5zAjgw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 31/63] pmdomain: ti: Add a null pointer check to the omap_prm_domain_init
Date: Mon, 16 Sep 2024 13:44:10 +0200
Message-ID: <20240916114222.174986682@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114221.021192667@linuxfoundation.org>
References: <20240916114221.021192667@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

commit 5d7f58ee08434a33340f75ac7ac5071eea9673b3 upstream.

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Link: https://lore.kernel.org/r/20240118054257.200814-1-chentao@kylinos.cn
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[Xiangyu: Modified to apply on 6.1.y]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
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


