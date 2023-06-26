Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1E7134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4ECC433C0;
	Mon, 26 Jun 2023 18:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803415;
	bh=zN4DjmB1ti/yxFGysYgocZtEa1PR+w260NfbTfJ/K7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVmMJqfCMUKx5/hfsPM86hwiDx+Vrdk7TIV1wHP/FDSqUBkTjMAahvJgSFpLm9IpO
	 s6fn7mQ1gw9p8g489JnVY6PrcyLEbeK559r0ZV8ZGPc5gqVU1S0eiocGi+hVZfxulN
	 QmJOqsyiDM4k3Q7NqP/J9avQ3+NvXDoqM02B2Rfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathu Baronia <prathubaronia2011@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>,
	Ingo Molnar <mingo@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.3 053/199] scripts: fix the gfp flags header path in gfp-translate
Date: Mon, 26 Jun 2023 20:09:19 +0200
Message-ID: <20230626180807.905545560@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Prathu Baronia <prathubaronia2011@gmail.com>

commit 2049a7d0cbc6ac8e370e836ed68597be04a7dc49 upstream.

Since gfp flags have been shifted to gfp_types.h so update the path in
the gfp-translate script.

Link: https://lkml.kernel.org/r/20230608154450.21758-1-prathubaronia2011@gmail.com
Fixes: cb5a065b4ea9c ("headers/deps: mm: Split <linux/gfp_types.h> out of <linux/gfp.h>")
Signed-off-by: Prathu Baronia <prathubaronia2011@gmail.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nicolas Schier <nicolas@fjasle.eu>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gfp-translate |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/scripts/gfp-translate
+++ b/scripts/gfp-translate
@@ -63,11 +63,11 @@ fi
 
 # Extract GFP flags from the kernel source
 TMPFILE=`mktemp -t gfptranslate-XXXXXX` || exit 1
-grep -q ___GFP $SOURCE/include/linux/gfp.h
+grep -q ___GFP $SOURCE/include/linux/gfp_types.h
 if [ $? -eq 0 ]; then
-	grep "^#define ___GFP" $SOURCE/include/linux/gfp.h | sed -e 's/u$//' | grep -v GFP_BITS > $TMPFILE
+	grep "^#define ___GFP" $SOURCE/include/linux/gfp_types.h | sed -e 's/u$//' | grep -v GFP_BITS > $TMPFILE
 else
-	grep "^#define __GFP" $SOURCE/include/linux/gfp.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
+	grep "^#define __GFP" $SOURCE/include/linux/gfp_types.h | sed -e 's/(__force gfp_t)//' | sed -e 's/u)/)/' | grep -v GFP_BITS | sed -e 's/)\//) \//' > $TMPFILE
 fi
 
 # Parse the flags


