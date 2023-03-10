Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CCA8489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903D4C433EF;
	Fri, 10 Mar 2023 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458005;
	bh=7Vqivv2NNq68gYaWBtIFdf0aST/QtLTFZOoh1fSAtwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFnNiPdKEirssv+Xzx8WsiBPa9fsCrGLukYAaOuen66JDxzP9q7VwKju6GneM+GTX
	 RxHKCYXOUUjv4PIm2RFlFyELuL6bko6RGuHwsJI+Eb0eSh2p9kWGKowTEn+Gnp8rek
	 CCu+48O2lb1KKBsaFE4ELp0bnoF0bLS8Vwn5ig/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jkl820.git@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 132/252] docs/scripts/gdb: add necessary make scripts_gdb step
Date: Fri, 10 Mar 2023 14:38:22 +0100
Message-Id: <20230310133722.802464458@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakob Koschel <jkl820.git@gmail.com>

[ Upstream commit 6b219431037bf98c9efd49716aea9b68440477a3 ]

In order to debug the kernel successfully with gdb you need to run
'make scripts_gdb' nowadays.

This was changed with the following commit:

Commit 67274c083438340ad16c ("scripts/gdb: delay generation of gdb
constants.py")

In order to have a complete guide for beginners this remark
should be added to the offial documentation.

Signed-off-by: Jakob Koschel <jkl820.git@gmail.com>
Link: https://lore.kernel.org/r/20230112-documentation-gdb-v2-1-292785c43dc9@gmail.com
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/dev-tools/gdb-kernel-debugging.rst | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/dev-tools/gdb-kernel-debugging.rst b/Documentation/dev-tools/gdb-kernel-debugging.rst
index 19df79286f000..afe4bc206486c 100644
--- a/Documentation/dev-tools/gdb-kernel-debugging.rst
+++ b/Documentation/dev-tools/gdb-kernel-debugging.rst
@@ -39,6 +39,10 @@ Setup
   this mode. In this case, you should build the kernel with
   CONFIG_RANDOMIZE_BASE disabled if the architecture supports KASLR.
 
+- Build the gdb scripts (required on kernels v5.1 and above)::
+
+    make scripts_gdb
+
 - Enable the gdb stub of QEMU/KVM, either
 
     - at VM startup time by appending "-s" to the QEMU command line
-- 
2.39.2



