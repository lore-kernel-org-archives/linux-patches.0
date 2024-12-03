Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D9F1F6694;
	Tue,  3 Dec 2024 14:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236856; cv=none; b=saMkdX97TLBVsH5sO4IoHABJOMPQe7utRFDETHG8wjCOlBWdINA/4IACZnDCV7drIpZQ0Nip9glwAHycLw9+pKHlRl9Fik/8xmfoHpSzGhPM4foQ730yrmGuL+83aP+8IiW5UnlsVq9ND8KOHk1/RWe6AGsGUv5A2r9/C8SbAiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236856; c=relaxed/simple;
	bh=DyOCUul1F6vV13Hfd+hjdtYK5u2uZJ4DGjhysn2HzbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0S7J3hOBHg5u4AVJJ7WWTyoPwjAf//NeM+x3Pckj2DHHq5VmK68GzLT6O5ihvMLFS+832x4T9329VbxPHZE3A3pUxv4mYCHDwnh/jytl+TNWIwVLVHxt8Iw1KH/gxnb+H6L5kme/u3iKAOL5zE73uvhGbouYnttCTnxQgglgBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIx8zBuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIx8zBuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E405C4CED6;
	Tue,  3 Dec 2024 14:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236856;
	bh=DyOCUul1F6vV13Hfd+hjdtYK5u2uZJ4DGjhysn2HzbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIx8zBuYDQvg02sjBzQPuY3ppO8Q+6NbrjWimotujk8W3uxZa2xMtXhj9w2noSP+U
	 DUM/d4pbytsJAgacJu++oTR1x/GDxBuL+p+0J2T/Pi2FcX2tRFOnSi0MB3gIITKYns
	 VusL26k0R+EPFL5GQftIp6OYVQRn2Qv2bEIrDVvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Lin Feng <linf@wangsu.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 4.19 105/138] tty: ldsic: fix tty_ldisc_autoload sysctls proc_handler
Date: Tue,  3 Dec 2024 15:32:14 +0100
Message-ID: <20241203141927.582283451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -854,7 +854,7 @@ static struct ctl_table tty_table[] = {
 		.data		= &tty_ldisc_autoload,
 		.maxlen		= sizeof(tty_ldisc_autoload),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &zero,
 		.extra2		= &one,
 	},


