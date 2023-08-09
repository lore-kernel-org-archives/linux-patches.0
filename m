Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D85117731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869F7C433C7;
	Wed,  9 Aug 2023 11:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579218;
	bh=iWdoR3Gz8Rm0s5SUotJWyAZ7oSl2Ulccg10t4TUr22M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqVFvWth2yzRM35tzLMo7Bc+0wkCdkEwX+OnSYmr1UOqCcsW/nlbvW1XaQxC2Mr5k
	 a8Y+BeJYD3lxVSBKPNp7wKymPw37suNW3bUF5qSLdxxR/stUTSC/UzEF+zVl9rx4RP
	 DFc7oHUC9gtv78at7lEJjoB6E/d18SUUwFfb0RwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 4.14 118/204] xtensa: ISS: fix call to split_if_spec
Date: Wed,  9 Aug 2023 12:40:56 +0200
Message-ID: <20230809103646.555877097@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Max Filippov <jcmvbkbc@gmail.com>

commit bc8d5916541fa19ca5bc598eb51a5f78eb891a36 upstream.

split_if_spec expects a NULL-pointer as an end marker for the argument
list, but tuntap_probe never supplied that terminating NULL. As a result
incorrectly formatted interface specification string may cause a crash
because of the random memory access. Fix that by adding NULL terminator
to the split_if_spec argument list.

Cc: stable@vger.kernel.org
Fixes: 7282bee78798 ("[PATCH] xtensa: Architecture support for Tensilica Xtensa Part 8")
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/platforms/iss/network.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/xtensa/platforms/iss/network.c
+++ b/arch/xtensa/platforms/iss/network.c
@@ -234,7 +234,7 @@ static int tuntap_probe(struct iss_net_p
 
 	init += sizeof(TRANSPORT_TUNTAP_NAME) - 1;
 	if (*init == ',') {
-		rem = split_if_spec(init + 1, &mac_str, &dev_name);
+		rem = split_if_spec(init + 1, &mac_str, &dev_name, NULL);
 		if (rem != NULL) {
 			pr_err("%s: extra garbage on specification : '%s'\n",
 			       dev->name, rem);


