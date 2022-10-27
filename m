Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7752AD23
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 17:05:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D454C433C1;
	Thu, 27 Oct 2022 17:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1666890306;
	bh=zfE/Ce8C7SeXkMoyhG3k3l1Xp0JNa1AVl0wry40Duik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fi8rXIFtiBJhwExie8pyACOqToPFjViQOJgYPvOzOFGQ/RlI207ZL2MfZLr3zjXTf
	 P1hQHCxMtnkySasmfAswGOje4LC2ewcTeZa78iy5agpEsPdC14jmm2/UIHLU16BSY5
	 +LZgkWi6xskhJ01JQdmEUWtgZGtftJ5oXxebvWy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 5.10 20/79] kbuild: Add skip_encoding_btf_enum64 option to pahole
Date: Thu, 27 Oct 2022 18:55:30 +0200
Message-Id: <20221027165055.072218417@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165054.270676357@linuxfoundation.org>
References: <20221027165054.270676357@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Rodriguez Reboredo <yakoyoku@gmail.com>

New pahole (version 1.24) generates by default new BTF_KIND_ENUM64 BTF tag,
which is not supported by stable kernel.

As a result the kernel with CONFIG_DEBUG_INFO_BTF option will fail to
compile with following error:

  BTFIDS  vmlinux
FAILED: load BTF from vmlinux: Invalid argument

New pahole provides --skip_encoding_btf_enum64 option to skip BTF_KIND_ENUM64
generation and produce BTF supported by stable kernel.

Adding this option to scripts/pahole-flags.sh.

This change does not have equivalent commit in linus tree, because linus tree
has support for BTF_KIND_ENUM64 tag, so it does not need to be disabled.

Signed-off-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/pahole-flags.sh |    4 ++++
 1 file changed, 4 insertions(+)

--- a/scripts/pahole-flags.sh
+++ b/scripts/pahole-flags.sh
@@ -14,4 +14,8 @@ if [ "${pahole_ver}" -ge "118" ] && [ "$
 	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_vars"
 fi
 
+if [ "${pahole_ver}" -ge "124" ]; then
+	extra_paholeopt="${extra_paholeopt} --skip_encoding_btf_enum64"
+fi
+
 echo ${extra_paholeopt}


