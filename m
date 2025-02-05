Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E611D8634E;
	Wed,  5 Feb 2025 14:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766351; cv=none; b=A/2KA54U/Bt+fbxjq4tFUrI9r2mTc3Ayr/m+fMrj2lvoSQ/o91n3y42o+MeU8TLsSdzVcatWntpfd64H/We9+9q5rWvMMSDcPxKf5qbCRQ3D495R8BOIhHTx83pZsAPrBKC4l4PT/9EYZ5i9SuM+OdDv1C4W4s+6Yh/wCSw8Ejc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766351; c=relaxed/simple;
	bh=FTTnbDhk+/4UmYuf3DVZeATIMyOPHZl+AnHKrua5A7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZZvskK1yh+N0qYSu6X8nhMlOPQPA6buMH+b7lxE7aM0UlNupqSx4jJjGsupZCTFE6tiNv+fAmljndI4iGrBeiVVL7FZo8cKY8FS4baZNEU7aSuqmCPuV38zYGDEnRJHxmwMH9358FgtbEdFKhWhR9rHe9Tt19p306ItuzZ2yW7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPN7JQtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPN7JQtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25248C4CED1;
	Wed,  5 Feb 2025 14:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766350;
	bh=FTTnbDhk+/4UmYuf3DVZeATIMyOPHZl+AnHKrua5A7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPN7JQtXAja4rgMRxjXHAK2xcz8GjHusujlitZ3SAhceK4Mq5ESIfeB9KoucOsw2g
	 1kDz3OmGTskrLHhZ+E5SXOZF+vZpN6ikCxP2CuiU4rFGIpFhOl5J+uVw1ddvQ0WwD4
	 QUevS7r1G6cgfhxS1wZU6bB5oIZ771d9Cl60UuC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 265/623] platform/x86: x86-android-tablets: Add missing __init to get_i2c_adap_by_*()
Date: Wed,  5 Feb 2025 14:40:07 +0100
Message-ID: <20250205134506.369589051@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 981fd70a5ac4347368fa8a3329b7d67f1c567ee7 ]

get_i2c_adap_by_handle() and get_i2c_adap_by_pci_parent() both are only
used by x86_instantiate_i2c_client() which is __init itself and in case
of the latter it also uses match_parent() which is also __init.

Fixes: 5b78e809f948 ("platform/x86: x86-android-tablets: Add support for getting i2c_adapter by PCI parent devname()")
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20241204204227.95757-2-hdegoede@redhat.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
index 4218afcec0e9b..40b5cd9b172f1 100644
--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -157,7 +157,7 @@ static struct gpiod_lookup_table * const *gpiod_lookup_tables;
 static const struct software_node *bat_swnode;
 static void (*exit_handler)(void);
 
-static struct i2c_adapter *
+static __init struct i2c_adapter *
 get_i2c_adap_by_handle(const struct x86_i2c_client_info *client_info)
 {
 	acpi_handle handle;
@@ -177,7 +177,7 @@ static __init int match_parent(struct device *dev, const void *data)
 	return dev->parent == data;
 }
 
-static struct i2c_adapter *
+static __init struct i2c_adapter *
 get_i2c_adap_by_pci_parent(const struct x86_i2c_client_info *client_info)
 {
 	struct i2c_adapter *adap = NULL;
-- 
2.39.5



