Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040747;
	b=gBgJh32ursecQWEtxTTezjr0ojOrTpqPo+wgyx1Y0Itw5f7ppTXrU+96pjpD10q3ao5e
	 3boKPLnIp8sWSj1E25lroEqQ4DuiNzOBr+pX/ZGqPfBgsElA5Y8OhVV/PfdYCQtImufow
	 lG2Uw+4+a1XBEtW57MkK1w+W3iNOfaCwtIoLACM3O9+5Krgs3UbKD1LBfDfNXpi0lqPyb
	 bSp6+bsOPkNKcZQ7gpjoqllffye/JbaU+KSYtrvWYgshTKu14YtYWDdXjhlAhDH4PUQTf
	 aZrGFfUFlPWkm0TK54aKQNOYNvFW2T5X95pynASkUvejWJVUebTOKzx1YdNrIXwYGag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7iQRWuL5mWluCaJx+qZSFWSZSx/FbMtllO9buBAF++Q=;
	b=KdDiCYbK25a8jH393MYC0PKBy8kukxrA/0OQ245JBvcMsYzalF0EYKaZPeVNLbpGkPX3
	 GX0iZLFZJTGQ2mG7Yl+mDGgzsLKWqBOKSxknkivfislMkmFw42Qu2nu5oW09baGkVA3sF
	 KK6Bu6KJrF8EISj0VOk375n7cw1+7/i74X3vmdFiXFVsGL0Qusa+Tk5wNm5eXcGEVccIt
	 p8D0FnEK+anIbu6+m8R2sLGNCRUtMsUdN6O5SFxEdW4oygd/Fqr+C5YX3mGxX2bbYorXz
	 fYZ831i1ROgxfDZcHbfNSyvZedb0JjsByOLP8We/ameAKms3MUlVFMMm7oYdzu2uEfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8oQGe7G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75239606A31C;
	Wed, 18 Nov 2026 22:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j8oQGe7G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C540C1F000C4;
	Wed, 18 Nov 2026 22:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040747;
	bh=7iQRWuL5mWluCaJx+qZSFWSZSx/FbMtllO9buBAF++Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j8oQGe7GukkzumoeuTD7OqO0uFUk4lau6Hs+3xyS6Jo/VmQlEn0YUuHYMM65wAovh
	 vIiWNOOS0EfNcQoOy0IbElVuiBUZHgBlo7alctyIv/XeiiEMSQbCm59Ahn/Hub9GqQ
	 oUyfLE28tzc7GVWinB0H4xnJG5MiqkYkRtG0S8Ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Stancek <jstancek@redhat.com>,
	Nicolas Schier <nsc@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2540/3318] .gitignore: drop Module.markers
Date: Wed, 18 Nov 2026 15:52:42 +0100
Message-ID: <20261118150437.513898607@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d1a8ab3f98aaf..43a5ab4738653 100644
--- a/.gitignore
+++ b/.gitignore
@@ -66,7 +66,6 @@ modules.order
 /vmlinux-gdb.py
 /vmlinuz
 /System.map
-/Module.markers
 /modules.builtin
 /modules.builtin.modinfo
 /modules.nsdeps
-- 
2.53.0



