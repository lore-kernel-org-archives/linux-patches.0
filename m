Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C35215D5D4;
	Mon, 29 Jan 2024 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548413; cv=none; b=TOApFm/r12B8sXziug+/dAQRZYCvcWjnkdFQM0hsaJlETZbGX2swGGDI60o8gwf9PYacVZcF/BsoFHdgOeCOV7EOvVrIPINdQotaNnZ9cqYhxs51257iyEYNc/pKdbpanthcw4C548JxDu1IonTW1h8iiwttks4BC1/mwARa50k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548413; c=relaxed/simple;
	bh=Euatenru3DHV3FxLyGC+D6W3F/93oLqxM0KX/gEQk1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1WWsbwd9C4JjzW3ogNvrj18GKxK2OUDORB5UMiYKO2anTArrH/0ewpCmi0RMRWq3t8eqi7unwa5NcTNZ44Kd/Afa49CHlI68QdRFWEsd/05A70a6i+njJ42UDlEp+wxxcRhLRAct6Lc2L3/EXXXDYfnF0d007O7+e/ksvZpJz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZjo48F1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZjo48F1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8410C433F1;
	Mon, 29 Jan 2024 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548412;
	bh=Euatenru3DHV3FxLyGC+D6W3F/93oLqxM0KX/gEQk1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZjo48F1BWYp8KXtjOjVZ0sd6buAv29//pnQXd2t2Z9iH24IDFCGA/5Qt8a9h0Bbx
	 rcHXR6GFVUm/wExLvw1QstsGE+ccXOLfGV14jE92b3D76vL7aoDjkxwftAPcDoebk7
	 6fdgafFtWuKFn+3R0y/S5+0U4YNYtwHI8yjtqdCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Min-Hua Chen <minhuadotchen@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/331] docs: sparse: move TW sparse.txt to TW dev-tools
Date: Mon, 29 Jan 2024 09:01:05 -0800
Message-ID: <20240129170015.012228808@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Min-Hua Chen <minhuadotchen@gmail.com>

[ Upstream commit 253f68f413a87a4e2bd93e61b00410e5e1b7b774 ]

Follow Randy's advice [1] to move
Documentation/translations/zh_TW/sparse.txt
to
Documentation/translations/zh_TW/dev-tools/sparse.txt

[1] https://lore.kernel.org/lkml/bfab7c5b-e4d3-d8d9-afab-f43c0cdf26cf@infradead.org/

Cc: Randy Dunlap <rdunlap@infradead.org>
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
Link: https://lore.kernel.org/r/20230902052512.12184-2-minhuadotchen@gmail.com
Stable-dep-of: c48a7c44a1d0 ("docs: kernel_feat.py: fix potential command injection")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/translations/zh_TW/{ => dev-tools}/sparse.txt | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/translations/zh_TW/{ => dev-tools}/sparse.txt (100%)

diff --git a/Documentation/translations/zh_TW/sparse.txt b/Documentation/translations/zh_TW/dev-tools/sparse.txt
similarity index 100%
rename from Documentation/translations/zh_TW/sparse.txt
rename to Documentation/translations/zh_TW/dev-tools/sparse.txt
-- 
2.43.0



