Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D6C27D784;
	Tue, 27 May 2025 17:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366876; cv=none; b=BCMmGhG5VgUshVwlsyaZJj1UQy+uq1eGQJhOOWeLz6B2lAc7WNvfyn5ND4gPsnA8q2w/RHtp4LE5o0aiGTJNO0VMIHNX4/aJD2qqZAsQ3NUafZC0BihIQBqBOvc05/u0WFzkZcFndbs2GVW0YICB7MS5qBohnxRiKQmg8sIENi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366876; c=relaxed/simple;
	bh=O1vw5s1oQWBt9VZ+ybKLlUdD8BgwVvED0KI/GD4gyVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSZBMhVKWGIZHBJvsYtLGMbygzPb9jkkyNUkOa6r/r4k9J6u5H8iZ3ADgQh32hXgogrGjMxttzX5sCypZ6nGZwE2d/T+t1C+rna5Uy7W8lPzPvO3P2M3iVGyxKSq1OTlTqGqAwr7Q1xAy5RZlBklMhPsNVhh7Qh24ZCt6v+nw10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/q5bvym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/q5bvym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23E6C4CEE9;
	Tue, 27 May 2025 17:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366876;
	bh=O1vw5s1oQWBt9VZ+ybKLlUdD8BgwVvED0KI/GD4gyVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/q5bvymvgTC8sA6AcGI8mzn+4cfYzbp3ZviGcYe56ABo/fnufxzVseQSkoMFSVyd
	 6wP+tX+V22vNA4+KlUAmJcxGuY28WkJDyvCfTcgFgmVkD4zdfIBR1Sfi/abBnIRbWt
	 g3G1tT3Qisf0s+HjTX+odAEwbEwZ9U4tKmq5wtwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 205/783] PNP: Expand length of fixup id string
Date: Tue, 27 May 2025 18:20:02 +0200
Message-ID: <20250527162521.488520174@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



