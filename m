Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CE81EABD1;
	Tue, 15 Oct 2024 12:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994162; cv=none; b=ImTmtnKqzdFaz1wQrSqvPPxi3AGOn9fREJ56J0K4k0u8DnXtv9HYvWOjcBd+Q6byD8wxDWNKfU5ELLaN6N6OEKQ2eQhaVpqUPl4YeDNx588HivmK+ODXjqroBd0UHtjBz/zfNAIW0TF6/HAYBsnadWQLwMQhT6etiX97QQtikHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994162; c=relaxed/simple;
	bh=qiKYDaIvqjvYca6qTu/1wFjc0dlEyqj8Mm+UzYZkZxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RDJ59C8P+42syqDdnjJYikFaT01Af/eB/KPQSFdxhFSk5DABlzTTS+275vGlyDIebX0OeqtNUZOmRxgRal1jvCLE5yhZ6G/BEI2MO8OQk1TMfRfh9g/Nm5oAEZCNo11XPoZ3rN3qJOdeJQy+byjJkD3tGEt2oFKeEuULqj7/oto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o3XOLmzT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o3XOLmzT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A618C4CEC6;
	Tue, 15 Oct 2024 12:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994161;
	bh=qiKYDaIvqjvYca6qTu/1wFjc0dlEyqj8Mm+UzYZkZxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3XOLmzTzd3y4585pmCh4r8ux9OOnVDXYgGVy2612nC0KniTU5fjNFCv2SlXrG446
	 v28r+LfaEF+TTaEEQIVe36QLKbV1ST+5AbK9wVxVsFPoYLLibrnHb30L58Oj4gPokJ
	 xj1YbsnjQkFv++yyXaQAQjlwn3wRHF34vJOjxuwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 617/691] comedi: ni_routing: tools: Check when the file could not be opened
Date: Tue, 15 Oct 2024 13:29:25 +0200
Message-ID: <20241015112504.822505716@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruffalo Lavoisier <ruffalolavoisier@gmail.com>

[ Upstream commit 5baeb157b341b1d26a5815aeaa4d3bb9e0444fda ]

- After fopen check NULL before using the file pointer use

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
Link: https://lore.kernel.org/r/20240906203025.89588-1-RuffaloLavoisier@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c b/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
index d55521b5bdcb2..892a66b2cea66 100644
--- a/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
+++ b/drivers/comedi/drivers/ni_routing/tools/convert_c_to_py.c
@@ -140,6 +140,11 @@ int main(void)
 {
 	FILE *fp = fopen("ni_values.py", "w");
 
+	if (fp == NULL) {
+		fprintf(stderr, "Could not open file!");
+		return -1;
+	}
+
 	/* write route register values */
 	fprintf(fp, "ni_route_values = {\n");
 	for (int i = 0; ni_all_route_values[i]; ++i)
-- 
2.43.0



