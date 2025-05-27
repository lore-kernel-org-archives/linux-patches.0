Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7502CCC0;
	Tue, 27 May 2025 16:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364811; cv=none; b=Aog8np5X2N6sVDls3XlQfT276ArOFr6mQwwnsvPIhWzAj7blsfmCTJBGHMxg8qpRf1t9Cn306ZXse6/bFl0tFxlkmTAIdvjRwzfvPOe4wl8Quz9OWf7+/rmC6dPjraAnb2lmn9IJSIsjRDUOCqq70WgEu2XaGRTAZeCxwVWFFn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364811; c=relaxed/simple;
	bh=Yni708o8rHQyhv80Axpp5cJ9cq5MJzAZruYjFZ99K3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVvbLw5TIFSRj2PucAgkznBn1gS0uL+VxocdJ6cSD4dCZOCqNEoTSwTIOyFQjvQMHhasGI2q8+vCWgB3Xr8OIWLEpcBVS5+1Ew6XB4RemafsImuZoXpa8/1pEN1EX6tMDN1EU8zoVlenfBjlhqctd+HNwKV5saLkRDw55TR+EaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lnOz3lF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lnOz3lF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727F9C4CEE9;
	Tue, 27 May 2025 16:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364810;
	bh=Yni708o8rHQyhv80Axpp5cJ9cq5MJzAZruYjFZ99K3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lnOz3lF3WnfLSb9Xt7J0KZhM7WBn+iz0Y5P/UlRV9/K/7cfsGdoIzRH2/DomiwRa2
	 qJlTNU2dUfYnRNGwGrhsjY+3GueG/n2ASfwnteSnEM5EQENgVsa8Qqx9mxhYPrqC77
	 5PnOjcqhAl8PZisr3i/ACeQrN/UXkPYbUxbSMKbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 173/626] PNP: Expand length of fixup id string
Date: Tue, 27 May 2025 18:21:06 +0200
Message-ID: <20250527162452.045896989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 425b1c97b07f2290700f708edabef32861e2b2db ]

GCC 15's -Wunterminated-string-initialization saw that "id" was not
including the required trailing NUL character. Instead of marking "id"
with __nonstring[1], expand the length of the string as it is used in
(debugging) format strings that expect a properly formed C string.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=117178 [1]
Signed-off-by: Kees Cook <kees@kernel.org>
Link: https://patch.msgid.link/20250310222432.work.826-kees@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pnp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pnp.h b/include/linux/pnp.h
index b7a7158aaf65e..23fe3eaf242d6 100644
--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -290,7 +290,7 @@ static inline void pnp_set_drvdata(struct pnp_dev *pdev, void *data)
 }
 
 struct pnp_fixup {
-	char id[7];
+	char id[8];
 	void (*quirk_function) (struct pnp_dev *dev);	/* fixup function */
 };
 
-- 
2.39.5



