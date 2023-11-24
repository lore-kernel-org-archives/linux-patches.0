Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61FD34197;
	Fri, 24 Nov 2023 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j3Ow3pk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB6EC433C7;
	Fri, 24 Nov 2023 18:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850100;
	bh=Yhds5/PsrMANyQ8jL90UyqGckH1M2LlbHydebvX9nKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3Ow3pk/BIxNhaKoaXJFzs6lBJfQhPn6jr7eM9+ciW14yXqrHvG5pfO/A/xLXA/X2
	 0HfaWFiE3auqPIvrProtZddlZ+DwC4mhIPUctU+oUgkAGllzwqFqHK7yexmuwkB27l
	 QYbUagbkWy8caVgoPgwM1lxvl8bn70dAL9m3y2Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Justin Stitt <justinstitt@google.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 445/530] net: ethtool: Fix documentation of ethtool_sprintf()
Date: Fri, 24 Nov 2023 17:50:11 +0000
Message-ID: <20231124172041.644282878@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Andrew Lunn <andrew@lunn.ch>

commit f55d8e60f10909dbc5524e261041e1d28d7d20d8 upstream.

This function takes a pointer to a pointer, unlike sprintf() which is
passed a plain pointer. Fix up the documentation to make this clear.

Fixes: 7888fe53b706 ("ethtool: Add common function for filling out strings")
Cc: Alexander Duyck <alexanderduyck@fb.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20231028192511.100001-1-andrew@lunn.ch
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/ethtool.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -1045,10 +1045,10 @@ static inline int ethtool_mm_frag_size_m
 
 /**
  * ethtool_sprintf - Write formatted string to ethtool string data
- * @data: Pointer to start of string to update
+ * @data: Pointer to a pointer to the start of string to update
  * @fmt: Format of string to write
  *
- * Write formatted string to data. Update data to point at start of
+ * Write formatted string to *data. Update *data to point at start of
  * next string.
  */
 extern __printf(2, 3) void ethtool_sprintf(u8 **data, const char *fmt, ...);


