Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECF0C152DF6;
	Tue, 20 Feb 2024 21:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465347; cv=none; b=Rn5LlPQlprvhedb/qWtxHhWlrUqjGuTIBJ+DxSqtpJZtd9AUj2pN8AI62ibfKqx1ncm3eV/K80JfkrkbWb26rOpzqHPNSzl3hTib6z2H9TcT9b+hgCvEn+ED5NR9fo8/u2K+Q0hqGy6r8LPx6KtKrOIqc4SzluG7purPwfeEB04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465347; c=relaxed/simple;
	bh=PBmfLKsou6eap0jZWktEd6u1fYPbiyT+AIbkgwmlqYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ap/nOap3KacfMghznvsFHYPgRctQ6YbowhH03wy/xINH2PR4zX/pMd9a2Ved7oY0EgcokBPmrL00RKxvFFZtEQd8bo5mQxy/+RBIb2ItizT/flpT7XpurscKFH1M0rlsDfAD3YIIOnzDqOE7ffdY05um/Wx9d261ehsJnNNiMw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL8jwf6B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL8jwf6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD61C433F1;
	Tue, 20 Feb 2024 21:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465346;
	bh=PBmfLKsou6eap0jZWktEd6u1fYPbiyT+AIbkgwmlqYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eL8jwf6Boim4TXv0MWr6e1+hGmv6/NNE3kzsZ91fV5/l12iI03FojWx4njjckV2H8
	 0nKRuwcn4ET/0XF6kTfn+kWETzoGkxKTjuPuVNOSE/Fq4HD0sq8sGb7QEENB0mgwzK
	 XhxK5jMfiwLffR4bNCR0QLb3bBuHXm5/eKnw9bhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Forbes <jforbes@fedoraproject.org>,
	Salvatore Bonaccorso <carnil@debian.org>,
	Jani Nikula <jani.nikula@intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 6.7 293/309] docs: kernel_feat.py: fix build error for missing files
Date: Tue, 20 Feb 2024 21:57:32 +0100
Message-ID: <20240220205642.266866298@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vegard Nossum <vegard.nossum@oracle.com>

commit c23de7ceae59e4ca5894c3ecf4f785c50c0fa428 upstream.

If the directory passed to the '.. kernel-feat::' directive does not
exist or the get_feat.pl script does not find any files to extract
features from, Sphinx will report the following error:

    Sphinx parallel build error:
    UnboundLocalError: local variable 'fname' referenced before assignment
    make[2]: *** [Documentation/Makefile:102: htmldocs] Error 2

This is due to how I changed the script in c48a7c44a1d0 ("docs:
kernel_feat.py: fix potential command injection"). Before that, the
filename passed along to self.nestedParse() in this case was weirdly
just the whole get_feat.pl invocation.

We can fix it by doing what kernel_abi.py does -- just pass
self.arguments[0] as 'fname'.

Fixes: c48a7c44a1d0 ("docs: kernel_feat.py: fix potential command injection")
Cc: Justin Forbes <jforbes@fedoraproject.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: Jani Nikula <jani.nikula@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Link: https://lore.kernel.org/r/20240205175133.774271-2-vegard.nossum@oracle.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/sphinx/kernel_feat.py |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/sphinx/kernel_feat.py
+++ b/Documentation/sphinx/kernel_feat.py
@@ -109,7 +109,7 @@ class KernelFeat(Directive):
             else:
                 out_lines += line + "\n"
 
-        nodeList = self.nestedParse(out_lines, fname)
+        nodeList = self.nestedParse(out_lines, self.arguments[0])
         return nodeList
 
     def nestedParse(self, lines, fname):


