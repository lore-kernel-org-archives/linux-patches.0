Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39491BDF4;
	Wed,  3 Jan 2024 17:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DzX3AZdL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6CCC433C8;
	Wed,  3 Jan 2024 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301806;
	bh=vXujIubDNp069/Ad+tgQY8uRw1tsFyujctmFs9mGiaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzX3AZdLzfLS1yhdbZjFW3817puMBBKBd7IBQxxlmqsQxzqQn6Yb1VepAXjXXEMPr
	 8abig9+sKcu18Q01FSSn+wLxh9CXzeXx6h53m5XkpGieoMdoMYuAlW3Vg2y69ZQuKp
	 P2WkfcM/q0fqcfQLp8Rs3fNakGSLPfixPyu8OqHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 35/75] wifi: cfg80211: fix certs build to not depend on file order
Date: Wed,  3 Jan 2024 17:55:16 +0100
Message-ID: <20240103164848.466317065@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 3c2a8ebe3fe66a5f77d4c164a0bea8e2ff37b455 upstream.

The file for the new certificate (Chen-Yu Tsai's) didn't
end with a comma, so depending on the file order in the
build rule, we'd end up with invalid C when concatenating
the (now two) certificates. Fix that.

Cc: stable@vger.kernel.org
Reported-by: Biju Das <biju.das.jz@bp.renesas.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: fb768d3b13ff ("wifi: cfg80211: Add my certificate")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/certs/wens.hex |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/certs/wens.hex
+++ b/net/wireless/certs/wens.hex
@@ -84,4 +84,4 @@
 0xf0, 0xc7, 0x83, 0xbb, 0xa2, 0x81, 0x03, 0x2d,
 0xd4, 0x2a, 0x63, 0x3f, 0xf7, 0x31, 0x2e, 0x40,
 0x33, 0x5c, 0x46, 0xbc, 0x9b, 0xc1, 0x05, 0xa5,
-0x45, 0x4e, 0xc3
+0x45, 0x4e, 0xc3,


