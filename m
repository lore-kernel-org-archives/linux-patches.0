Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061159;
	b=iTnHhd9nyHdMHYQZlqB0uteCl+O77WQkNYWjP61RXDSYP704H0WGqe0jyxQvwRBPh9zN
	 WElMuAZoQii6UEGsYNPByaSbOX6kB6+CxjwqbFKGplCDDvj99ga181x2AmApAODSjNBix
	 Ci1+TV2HreyScEvCsIvTcvQlz86cyQHIPhGo07g0EtEx2a4zWM8Xy6KiYht4lLjCj6xrx
	 37SK+9RAIefJ1urUw27GlH3OhMPQxHafwB8dYYFMIzjPLiJt+Ogtv70uMR4i5x6gv9GEU
	 tn4DyofBt0wfEfwkCI3iuRVv1jqGDRO4Tl7kpk6sDl2hjNxWGlZEOGQ6wSD03c7xLWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6NA0DW0Nd8TsyXRklHy7UVM5SC7ai5tXsK//Z1Ce52w=;
	b=oDJG4y3MoOo+KsCWu6tjmqQ2fet3MmEsJAsy6TEYUS8ztG1x19I0hJRIUqcHHQxy8jx+
	 gdxT/J0Zd49J+kvTvZLstFoz98VnzIcNujEfSpVqD5ouc6xeVKPLrgauwigVxps4CpGIF
	 IJUxPeK39rEB8MfiKls+QHSUbZdh0RIcFNf9X6BQ19RLT8cAY/Eu5GguTOglQLLHSx+T9
	 NJaxcB9SEwDIke9e6BtbkSJJ0m9eQ7Bt5TnVCj5QZi5DSCVuLRTPrG4EDq4SP3RagY9D+
	 gFwcsXSezljPgt779HuXu2Y/xI8E3EPGC5sI/gjOCmGbifK8/4agyo6TInFT0N28d4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1Kk4uJ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE4E606A320;
	Thu, 19 Nov 2026 04:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U1Kk4uJ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 990681F000C4;
	Thu, 19 Nov 2026 04:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061159;
	bh=6NA0DW0Nd8TsyXRklHy7UVM5SC7ai5tXsK//Z1Ce52w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1Kk4uJ9X/Nvvy6bh4mD/mgi6d9pUOnG0U8549AvQYDOKoSY4gR7EHNImHP5rbe+G
	 61ZIL8yOlI7DflhTvkDdv8wlbcG/eIZrOORJy7KCSJBvpRmN1ZtnV5jTxeA52o0u6O
	 f4v8dpl9gN0iX9SzulXCHlcoxwE+7NFh6WOV6cPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1452/1848] .gitignore: drop Module.markers
Date: Wed, 18 Nov 2026 15:58:10 +0100
Message-ID: <20261118150020.198926454@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Stancek <jstancek@redhat.com>

[ Upstream commit a7d32fa14bc74d1786a2f0513b6f0815bd4be311 ]

commit fc5377668c3d ("tracing: Remove markers") deleted the marker code
and the modpost output. Follow-up commit 8723eaeff59a ("Kbuild: clean up
marker") removed it from clean and mrproper targets. Both are from 2009,
so the file is hopefully no longer in anyone's tree, drop it from
.gitignore as well.

Fixes: 8723eaeff59a ("Kbuild: clean up marker")
Signed-off-by: Jan Stancek <jstancek@redhat.com>
Reviewed-by: Nicolas Schier <nsc@kernel.org>
Link: https://patch.msgid.link/8cbe913b9f80dc6fea73a9e3d51429db2b38905f.1790838401.git.jstancek@redhat.com
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .gitignore | 1 -
 1 file changed, 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index 3d95f2b268e55..aef1933e81cef 100644
--- a/.gitignore
+++ b/.gitignore
@@ -61,7 +61,6 @@ modules.order
 /vmlinux-gdb.py
 /vmlinuz
 /System.map
-/Module.markers
 /modules.builtin
 /modules.builtin.modinfo
 /modules.nsdeps
-- 
2.53.0



