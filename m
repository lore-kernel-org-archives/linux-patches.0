Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2883A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUmosyVA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87B2C433C9;
	Wed, 15 Nov 2023 19:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077403;
	bh=XWgx0pg+FXwdu9AuCPzbNjVE2xVjD2UlTbTjsBRVAKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hUmosyVAbUXaMfgtgm8/JSoB1bRXndJq+jM50EMqL8T/4U5dah0VzX77PYDy2x+D9
	 yhc4HgouoZxoTuAavc4raDX5Ye4zUR8P0iIwGW8iVaWJKY3TPHq80uambbyGRwUF9h
	 Lo2TpPhWPzhvJhmHMtCcppE1bB0FZcXvP0NFoD/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/603] xen: irqfd: Use _IOW instead of the internal _IOC() macro
Date: Wed, 15 Nov 2023 14:13:29 -0500
Message-ID: <20231115191631.589124164@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 767e33ca47dd8ace7769e0b0c19d7b0c38b2f72d ]

_IOC() an internal helper that we should not use in driver code.  In
particular, we got the data direction wrong here, which breaks a number
of tools, as having "_IOC_NONE" should never be paired with a nonzero
size.

Use _IOW() instead.

Fixes: f8941e6c4c71 ("xen: privcmd: Add support for irqfd")
Reported-by: Arnd Bergmann <arnd@kernel.org>
Closes: https://lore.kernel.org/all/268a2031-63b8-4c7d-b1e5-8ab83ca80b4a@app.fastmail.com/
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/599ca6f1b9dd2f0e6247ea37bee3ea6827404b6d.1697439990.git.viresh.kumar@linaro.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/xen/privcmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/xen/privcmd.h b/include/uapi/xen/privcmd.h
index b143fafce84db..e145bca5105c5 100644
--- a/include/uapi/xen/privcmd.h
+++ b/include/uapi/xen/privcmd.h
@@ -138,6 +138,6 @@ struct privcmd_irqfd {
 #define IOCTL_PRIVCMD_MMAP_RESOURCE				\
 	_IOC(_IOC_NONE, 'P', 7, sizeof(struct privcmd_mmap_resource))
 #define IOCTL_PRIVCMD_IRQFD					\
-	_IOC(_IOC_NONE, 'P', 8, sizeof(struct privcmd_irqfd))
+	_IOW('P', 8, struct privcmd_irqfd)
 
 #endif /* __LINUX_PUBLIC_PRIVCMD_H__ */
-- 
2.42.0



