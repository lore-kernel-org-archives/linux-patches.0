Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD6A3DAAA8;
	Tue, 25 Aug 2026 13:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665409; cv=none; b=orZA0LrIceaSB/H2LXLgeSIc/2iJK184eMZrN2dleU0uOpVxJKdg32DZ0zB+smvEmGYYfsD8OhhNv3Cou0sK8BSWmMrePYsI1EN6oiiI3IyxEiyB511jWwS9XVbxIU4sJzc7MtxhxGAGvbziXscUAzAptbRPtIc+zteFNYbra/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665409; c=relaxed/simple;
	bh=C3LvkuFFXO17igqM4XRnSwp3DBhyjMf9ZuQXEfjWouE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dirlE1MAF86w2CEDSA9YC7TYUPLTOXnIKzDS/s7GDV01CuncnxeblRcU1YPHaofgSbnm/EVGZ3qU1AJ2irdhxObO0qGg1CJbLNFoYF9FEWXYST53kpa2ddteU0NbzSLwYD+jB7kFJLOqjuAcEa7jaSBfeTwcmSIQEbqwqr9O0oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pV5B81sJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pV5B81sJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E6C1F000E9;
	Tue, 25 Aug 2026 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665408;
	bh=2oXx3GsTladVVv8C4CkO0lOrgMcoMrBTPchfVAZ7VqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pV5B81sJog8wgJXVVW1KD/JKGxuwyogh76nzHGt1A+KAXjAQSXTO1obCb4VvZqgBL
	 2E1AyPEWQTUphLC9IGg8OBFY5k8VfDk/qUXFvaZ3eKF6Phftu7gvGYzpOZ/HSxKXiq
	 Tim+r2IlFjnmGZy23KYjgRlrKrMh9SgWDPIOsjSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>
Subject: [PATCH 6.12 07/77] hwmon: (ltc4286) Fix symbol namespace of MODULE_IMPORT_NS()
Date: Tue, 25 Aug 2026 15:25:29 +0200
Message-ID: <20260825132541.843098005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.x90@mail.toshiba>

In 6.12.y, the namespace specified in MODULE_IMPORT_NS() does not require
a string. This removes the quotes from the namespace name.

Fixes: 7fd4a5682c78 ("hwmon: (ltc4286) Add missing MODULE_IMPORT_NS("PMBUS")")
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/ltc4286.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/ltc4286.c
+++ b/drivers/hwmon/pmbus/ltc4286.c
@@ -173,4 +173,4 @@ module_i2c_driver(ltc4286_driver);
 MODULE_AUTHOR("Delphine CC Chiu <Delphine_CC_Chiu@wiwynn.com>");
 MODULE_DESCRIPTION("PMBUS driver for LTC4286 and compatibles");
 MODULE_LICENSE("GPL");
-MODULE_IMPORT_NS("PMBUS");
+MODULE_IMPORT_NS(PMBUS);


