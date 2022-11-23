Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7951C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BECC4C433D6;
	Wed, 23 Nov 2022 09:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669196226;
	bh=yyRLcOZkVFdF4LGAYIWZzTY3gJNCP7TaUXIpFbcdzNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1mSchYr9x7YUA0Cg7gVW577kh4jk2z/IL4R76clpEEign3HmhkNrAt3STudiHJmA
	 ib6j4nbCZTEiAMmf+gB+EeuHBk+PbVerzfmfl6312i8F3bHj7VUubXn21sB6OYr7D4
	 z/HaXGhQY1tEn65wFwGuDRJG0uLKOCEZ3OjNpDVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.15 154/181] docs: update mediator contact information in CoC doc
Date: Wed, 23 Nov 2022 09:51:57 +0100
Message-Id: <20221123084609.009910668@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084602.707860461@linuxfoundation.org>
References: <20221123084602.707860461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shuah Khan <skhan@linuxfoundation.org>

commit 5fddf8962b429b8303c4a654291ecb6e61a7d747 upstream.

Update mediator contact information in CoC interpretation document.

Cc: <stable@vger.kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20221011171417.34286-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/process/code-of-conduct-interpretation.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/process/code-of-conduct-interpretation.rst
+++ b/Documentation/process/code-of-conduct-interpretation.rst
@@ -51,7 +51,7 @@ the Technical Advisory Board (TAB) or ot
 uncertain how to handle situations that come up.  It will not be
 considered a violation report unless you want it to be.  If you are
 uncertain about approaching the TAB or any other maintainers, please
-reach out to our conflict mediator, Joanna Lee <joanna.lee@gesmer.com>.
+reach out to our conflict mediator, Joanna Lee <jlee@linuxfoundation.org>.
 
 In the end, "be kind to each other" is really what the end goal is for
 everybody.  We know everyone is human and we all fail at times, but the


