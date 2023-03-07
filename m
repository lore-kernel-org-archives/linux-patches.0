Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47A3BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:31:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D2CC433D2;
	Tue,  7 Mar 2023 18:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213896;
	bh=hZDQs9eXUYPuDZMUCc+ieuOZlH3GgKGjFisfM2ka49w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrqMuFHPsNcipIit5ECplC5ipbX2AT7+jRu8D8S/sjH/DjjsvlLXDNAdebtWbqkga
	 gIBRsDKmucDw7e2d7rbEtcKaUEM0+CvCVyzFGTwDwDh6odYLaarKlLfE8QBKGJej2a
	 HO5vSue7AmbFzgBLwbI7WI0rYWTtzqhQ5i8iJ+kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Corey Minyard <cminyard@mvista.com>
Subject: [PATCH 6.1 654/885] ipmi: ipmb: Fix the MODULE_PARM_DESC associated to retry_time_ms
Date: Tue,  7 Mar 2023 17:59:48 +0100
Message-Id: <20230307170030.563562951@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit befb28f2676a65a5a4cc4626ae224461d8785af6 upstream.

'This should be 'retry_time_ms' instead of 'max_retries'.

Fixes: 63c4eb347164 ("ipmi:ipmb: Add initial support for IPMI over IPMB")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-Id: <0d8670cff2c656e99a832a249e77dc90578f67de.1675591429.git.christophe.jaillet@wanadoo.fr>
Cc: stable@vger.kernel.org
Signed-off-by: Corey Minyard <cminyard@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_ipmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/ipmi/ipmi_ipmb.c
+++ b/drivers/char/ipmi/ipmi_ipmb.c
@@ -27,7 +27,7 @@ MODULE_PARM_DESC(bmcaddr, "Address to us
 
 static unsigned int retry_time_ms = 250;
 module_param(retry_time_ms, uint, 0644);
-MODULE_PARM_DESC(max_retries, "Timeout time between retries, in milliseconds.");
+MODULE_PARM_DESC(retry_time_ms, "Timeout time between retries, in milliseconds.");
 
 static unsigned int max_retries = 1;
 module_param(max_retries, uint, 0644);


