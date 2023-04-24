Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAF62108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320AAC433D2;
	Mon, 24 Apr 2023 13:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343185;
	bh=tCCynyrnIJfQB2Eg5feIoBHwGYY3Vk1ymQA+xiDetCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wro4PM+mq33362miHaQfyADzoNh5aVlmTOTnrzhH8d9SzarwTvFh6lARauiTgYh1U
	 NA6E1jHSWKHxdnDXwnejEVLBPPm9bT8CZIj3Nz3SoVxyw5wgVUfKpNxGjULRNIEeWH
	 NTAmEFgBzSLNLc6zFuxFmfpRQMtGvWofc8A9ey88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ekaterina Orlova <vorobushek.ok@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	James Bottomley <jejb@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	keyrings@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.2 110/110] ASN.1: Fix check for strdup() success
Date: Mon, 24 Apr 2023 15:18:12 +0200
Message-Id: <20230424131140.757356526@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ekaterina Orlova <vorobushek.ok@gmail.com>

commit 5a43001c01691dcbd396541e6faa2c0077378f48 upstream.

It seems there is a misprint in the check of strdup() return code that
can lead to NULL pointer dereference.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 4520c6a49af8 ("X.509: Add simple ASN.1 grammar compiler")
Signed-off-by: Ekaterina Orlova <vorobushek.ok@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: James Bottomley <jejb@linux.ibm.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: keyrings@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org
Link: https://lore.kernel.org/r/20230315172130.140-1-vorobushek.ok@gmail.com/
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/asn1_compiler.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -625,7 +625,7 @@ int main(int argc, char **argv)
 	p = strrchr(argv[1], '/');
 	p = p ? p + 1 : argv[1];
 	grammar_name = strdup(p);
-	if (!p) {
+	if (!grammar_name) {
 		perror(NULL);
 		exit(1);
 	}


