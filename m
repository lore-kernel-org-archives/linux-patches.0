Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD35511706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42322C433C8;
	Mon, 11 Sep 2023 15:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444560;
	bh=Khniuww7dWpYkvCDWlP6N5IidQ3iZwBXbLWQn0MC/OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VLcE6S/SVxDFKU+CEItj9+4zdBhGLTFAX2FQO241IwW7w1NJE71cIIfodbykVebSI
	 UAVWcd522X5/arqYrIAwgxmNgfdm2SrEqsdZdP1REiIGe5Ey6enB09UImwAMR84l6H
	 KKqqZlzTqqPN/2EUDaWMdQ5F5kXYxOYj8jxpv9bA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Ming <machel@vivo.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 036/600] platform/x86: think-lmi: Use kfree_sensitive instead of kfree
Date: Mon, 11 Sep 2023 15:41:09 +0200
Message-ID: <20230911134634.667447458@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Wang Ming <machel@vivo.com>

[ Upstream commit 1da0893aed2e48e2bdf37c29b029f2e060d25927 ]

key might contain private part of the key, so better use
kfree_sensitive to free it.

Signed-off-by: Wang Ming <machel@vivo.com>
Link: https://lore.kernel.org/r/20230717101114.18966-1-machel@vivo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index 3cbb92b6c5215..f6290221d139d 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -719,12 +719,12 @@ static ssize_t cert_to_password_store(struct kobject *kobj,
 	/* Format: 'Password,Signature' */
 	auth_str = kasprintf(GFP_KERNEL, "%s,%s", passwd, setting->signature);
 	if (!auth_str) {
-		kfree(passwd);
+		kfree_sensitive(passwd);
 		return -ENOMEM;
 	}
 	ret = tlmi_simple_call(LENOVO_CERT_TO_PASSWORD_GUID, auth_str);
 	kfree(auth_str);
-	kfree(passwd);
+	kfree_sensitive(passwd);
 
 	return ret ?: count;
 }
-- 
2.40.1



