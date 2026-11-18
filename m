Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059722;
	b=j6oDR15DUrrKIW4Td95MfbiuegcLtzB1UURdDXsM2AObQ+KFDyzodQ5FqIqMI/qcVgBv
	 dePgl23xnQuj7gjdWBW6xRNoQmnls+uEbVXmDIHXEajOFllynwTi/iyTTBiG5ihwkiqrf
	 snkODvURCpIqsFj7IWKfcesfOCFmaCRVw8lOjoh41iQodmgqvsQfiaS/8An4+EgNUc7ys
	 HDepnFynNusKY+q0otBFfc6dGoVaT2E6jpMzN9yGUCcy8w9CS3jYo8Dm6syupvziBQgnl
	 mw8pZz1+Y59joT/o4+z7KTrt5gE2bHve8RvxvgciNNmeHWT2AC9Fo9s7+aofjDe16nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WcbEmPsmjzdQTAqwh6rme1Sxzznrsx/b/YVXAbA4GZ4=;
	b=m0rr3TqMqMisuOyWDhFy6u+BpU0J6Osai8em2FT54oP7NMPhaujyyfxcKr7HRPlNJY9c
	 tUpqtZr76d8eUXWfbjQvSAGilYAZkJRhkVbSZ6MERqlBbgjCGfuVKK0fDAR5NB/s6RwNv
	 oBBp3JbDdEt372DNGk+i6C4LUaiAoqwNZiZbDy3SPu/zW/qsZBP7YsAY3UqPYO+A62+aK
	 a92mHz6hoFEK2MzkU8xHTcgbbIzLrY83x1FiyT11rnSZeY1YTox1uwdxluhULC/aG2zUN
	 qWYbmjO8ELFeespS1M6neZJAQ9k2rBHBkeY+5MgypqronYAFoqCx6kmYM6HLU9Exlnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqdHXzLb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B2C606A325;
	Thu, 19 Nov 2026 03:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oqdHXzLb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925A91F000C4;
	Thu, 19 Nov 2026 03:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059721;
	bh=WcbEmPsmjzdQTAqwh6rme1Sxzznrsx/b/YVXAbA4GZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqdHXzLblVmbWeMlIGRhj+mT4UsFV9kb8mhlqKfuYNq1acMwOHn/lHEWO77aKWjPV
	 NRoY5uOc1pSrKJe7RohbSdX8fb5gW3rK5UGyQxCUT9obn4NKpGqvL0lF5/bcskMS5g
	 HBf/MlFC76J0QlOa9+pR7gFQg3Vi5zdcYXYHLbCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make_ruc2021@163.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0944/1848] i2c: acpi: Fix adapter reference leak in i2c_acpi_new_device_by_fwnode()
Date: Wed, 18 Nov 2026 15:49:42 +0100
Message-ID: <20261118145956.583406397@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make_ruc2021@163.com>

[ Upstream commit a65917d0a22f9b10694853b725f9cd399fc3ef4d ]

i2c_acpi_new_device_by_fwnode() obtains an i2c_adapter through
i2c_acpi_find_adapter_by_handle(). That helper uses bus_find_device()
internally, so it returns the adapter with a reference held:

        adapter = i2c_verify_adapter(dev);
        if (!adapter)
                put_device(dev);

        return adapter;

The reference is only put on the failure path inside that helper. The
caller owns it otherwise. i2c_acpi_new_device_by_fwnode() never drops
it, neither on the -EPROBE_DEFER path nor after
i2c_new_client_device(), so every call leaks one reference on the
adapter and the adapter can never be released.

i2c_new_client_device() does not consume that reference. It registers
the new client with the adapter as its parent, and device_add() takes
its own reference on the parent, which device_del() releases when the
client goes away.  The reference obtained by the lookup is a separate
one and has to be dropped here.

i2c_acpi_notify() in the same file already does exactly this. It takes
the adapter from the same helper, registers the client through
i2c_acpi_register_device(), which calls i2c_new_client_device(), and
then puts the reference.

i2c_new_client_device() gives the client its own reference on the
adapter, so ours can be dropped unconditionally.

Found by code review.

Fixes: 605f8fc22442 ("i2c: core: Add new i2c_acpi_new_device helper function")
Signed-off-by: Ma Ke <make_ruc2021@163.com>
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://patch.msgid.link/20261012013421.3597430-1-make_ruc2021@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/i2c-core-acpi.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 6f8532ccea850..b9b4b7a98a39d 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -496,6 +496,7 @@ struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
 {
 	struct i2c_acpi_lookup lookup;
 	struct i2c_adapter *adapter;
+	struct i2c_client *client;
 	struct acpi_device *adev;
 	LIST_HEAD(resource_list);
 	int ret;
@@ -523,7 +524,10 @@ struct i2c_client *i2c_acpi_new_device_by_fwnode(struct fwnode_handle *fwnode,
 	if (!adapter)
 		return ERR_PTR(-EPROBE_DEFER);
 
-	return i2c_new_client_device(adapter, info);
+	client = i2c_new_client_device(adapter, info);
+	put_device(&adapter->dev);
+
+	return client;
 }
 EXPORT_SYMBOL_GPL(i2c_acpi_new_device_by_fwnode);
 
-- 
2.53.0



