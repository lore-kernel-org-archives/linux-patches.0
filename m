Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10597611A
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE8FC433C8;
	Mon, 28 Aug 2023 10:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218874;
	bh=3K01kXFTHHfP8uSExz2kSxtSr75XdfIPqIGIR97gREo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rqe8hRMtd+l94eYJ7+AwfQzMJ7EM65Vbiow9lgiNq+Q5DyfZKdPuwfM03GCmrATD8
	 fOlUU32Z67kVMdeumccERU9ZQ63lQdQtZQ5CZ708xIc2zOWrJmV3A31ITcPsNSeost
	 Uol/UaBwa6n+8eZxIOM3xAGhcHRSfRCiRSwqvheo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH 6.1 087/122] of: unittest: Fix EXPECT for parse_phandle_with_args_map() test
Date: Mon, 28 Aug 2023 12:13:22 +0200
Message-ID: <20230828101159.297405374@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Rob Herring <robh@kernel.org>

commit 0aeae3788e28f64ccb95405d4dc8cd80637ffaea upstream.

Commit 12e17243d8a1 ("of: base: improve error msg in
of_phandle_iterator_next()") added printing of the phandle value on
error, but failed to update the unittest.

Fixes: 12e17243d8a1 ("of: base: improve error msg in of_phandle_iterator_next()")
Cc: stable@vger.kernel.org
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/20230801-dt-changeset-fixes-v3-1-5f0410e007dd@kernel.org
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/unittest.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@ -657,12 +657,12 @@ static void __init of_unittest_parse_pha
 	memset(&args, 0, sizeof(args));
 
 	EXPECT_BEGIN(KERN_INFO,
-		     "OF: /testcase-data/phandle-tests/consumer-b: could not find phandle");
+		     "OF: /testcase-data/phandle-tests/consumer-b: could not find phandle 12345678");
 
 	rc = of_parse_phandle_with_args_map(np, "phandle-list-bad-phandle",
 					    "phandle", 0, &args);
 	EXPECT_END(KERN_INFO,
-		   "OF: /testcase-data/phandle-tests/consumer-b: could not find phandle");
+		   "OF: /testcase-data/phandle-tests/consumer-b: could not find phandle 12345678");
 
 	unittest(rc == -EINVAL, "expected:%i got:%i\n", -EINVAL, rc);
 


