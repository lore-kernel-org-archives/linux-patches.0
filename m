Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55424229691;
	Thu, 12 Dec 2024 16:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020100; cv=none; b=uwU1p7wcJEJOQMX8+tRpQxhdV8JOl8ASuybYKCl5TmUSuNIGyFlc1P4PAm2MV7JG7bYFztXMQFo78MUrL+/lDTrly5+/USiLWVC9mKt9nlXgqJIRfiykD1tpPJSN3+MFKDdm/BBIDpXMVntvJrYZHzIYKEZZvccp3n7RMKBdyJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020100; c=relaxed/simple;
	bh=e//9K9SJaTbb8Ej8NrvTmDQJri8Lwv0SoLoFm34wCQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=stSFFEGeWTZLGY8IxLbmkVcJd4MYVoowrOH+tj17kIApGAsgwwWMfNABeWTXSm9ZEqwIUZO683hiViTi2enQCq6fPWXmP1Oytc/XE456fv6BjF/y1xafLaNPYI1jniazEn7QWU7WgUmN57Goc3a1geNGr0F2Eh7fj1IVUDbj18g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TymaDDWQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TymaDDWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62534C4CECE;
	Thu, 12 Dec 2024 16:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020100;
	bh=e//9K9SJaTbb8Ej8NrvTmDQJri8Lwv0SoLoFm34wCQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TymaDDWQJTNJczIT++bFkiUgrsLWu/KodAO0zTbgsC4pSdPVThQJbqMmpoqCncYcq
	 0mtkd9EdNn9FIOxq9YkvVO2tMcxGAYgtCqDPmDNZCQ0HINvY7YbkP+WTGp99i2rDnG
	 bsaBaRYohmf8y9xihqfhVOElsu/mMpJhJZGfVKY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Lin Feng <linf@wangsu.com>,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.1 377/772] tty: ldsic: fix tty_ldisc_autoload sysctls proc_handler
Date: Thu, 12 Dec 2024 15:55:22 +0100
Message-ID: <20241212144405.480334567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -830,7 +830,7 @@ static struct ctl_table tty_table[] = {
 		.data		= &tty_ldisc_autoload,
 		.maxlen		= sizeof(tty_ldisc_autoload),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec,
+		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
 	},


