Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4AF13CA93;
	Thu, 12 Dec 2024 17:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024406; cv=none; b=uiQO1HJwCF4uKWS84Ov5ko/Buz1lgn2ICXk4G+dq8Un+ggcKeh2O6agPKrV3h2Vd81CaNRAHf+SXpXFbTfrqTJUP9SHcwg99LX/7Z67g6ePG+dZqcQn6KZm5IVrPAt90kRI3L4vq8SnQCNpWsc6MbH4jdzCLrFU+tgCz2leakLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024406; c=relaxed/simple;
	bh=5G7oxpgonjtz2hRslfqbMm+uUjU6JdArT8WIWlhynHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o86Rs8vCosrnEO5oodSwya6mxL7CrqH4M55PGxSSNqrL+cTotq9imYFNDTXU1StCOIW/aXxf+8BHJk0zxEamlstxAjdyoSQ7wHgLV/AOf9zlPeY9ktl6TE87F73D9SYAQH8GdLCy5C+vdx1+lfLZ0eXXxt9oHIzbo3+0CxlD4RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3Tt+XJR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3Tt+XJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904A3C4CED0;
	Thu, 12 Dec 2024 17:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024406;
	bh=5G7oxpgonjtz2hRslfqbMm+uUjU6JdArT8WIWlhynHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3Tt+XJRwrE3DFbstAUgtu2DkAfEjziN1h+DlXsTDrzZRApzSCMWiusf4IXjJwAc5
	 4QeQr1oXA/g69ojW9AcNVfOesnocUvUWfM6XhkTOjaeSSeueUqEMq9ENgCjxjD0dQo
	 Qrk0FzaiuhidCi7tjQE3LX/eC05yU04byOgNQ7S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Lin Feng <linf@wangsu.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.10 256/459] tty: ldsic: fix tty_ldisc_autoload sysctls proc_handler
Date: Thu, 12 Dec 2024 15:59:54 +0100
Message-ID: <20241212144303.710367424@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>

commit 635a9fca54f4f4148be1ae1c7c6bd37af80f5773 upstream.

Commit 7c0cca7c847e ("tty: ldisc: add sysctl to prevent autoloading of
ldiscs") introduces the tty_ldisc_autoload sysctl with the wrong
proc_handler. .extra1 and .extra2 parameters are set to avoid other values
thant SYSCTL_ZERO or SYSCTL_ONE to be set but proc_dointvec do not uses
them.

This commit fixes this by using proc_dointvec_minmax instead of
proc_dointvec.

Fixes: 7c0cca7c847e ("tty: ldisc: add sysctl to prevent autoloading of ldiscs")
Cc: stable <stable@kernel.org>
Signed-off-by: Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>
Reviewed-by: Lin Feng <linf@wangsu.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20241112131357.49582-4-nicolas.bouchinet@clip-os.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_ldisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -856,7 +856,7 @@ static struct ctl_table tty_table[] = {
 		.data		= &tty_ldisc_autoload,
 		.maxlen		= sizeof(tty_ldisc_autoload),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},


