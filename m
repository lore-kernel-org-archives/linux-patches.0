Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97FC2EAE6;
	Mon, 23 Dec 2024 16:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969693; cv=none; b=ageAaI23+juREiLSkbOvhqekD7x1nu+O+FSNQhaxD0kSS9wP0RH8WJkSeJxrebdqt+Ib59+iVhFvx9JWWmlnaWhB8ofrp7sEkitD849R4Mzh4wFhlvkh05nvaxXbvOKn9Nu2WjJuRG1ovCxZH3BUKXkl1tTSaxttik+NmSpshyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969693; c=relaxed/simple;
	bh=xJdsEaV4xs3YLFMh8xNuiyKARpQB1WcLHcNhn3tXrwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bWJi8ZkuybO/e1mzxVrhozlevn11D914kFO9YygaSrjEtZq77pRf46g2mpFhgSe497OaihCMlCyeASd26mp8Cs7CcnRgA2PmxljpExY1SLWYwg3DHSzm6EZz81WtlqTAPPNozXAW43q/uQ9ZAshbCDHCsWcEACVQQiF7LYbkWWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFWTni2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFWTni2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD12C4CED4;
	Mon, 23 Dec 2024 16:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969693;
	bh=xJdsEaV4xs3YLFMh8xNuiyKARpQB1WcLHcNhn3tXrwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFWTni2zjvFPd7ZPWTyKy0Jvy+g69aa3PMNBKPlPov/41FpxyA2ZDCyxbuPPSbcVQ
	 Loir48AVe10uqJjXuohro91vWftDCSVItWgFxQyPJdp3ZB9xtuGKCkVP4548Az6y/g
	 jRwNZyLrXrIxMeq+WRZp4BMgmJmzvtJ1SPg425KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olaf Hering <olaf@aepfle.de>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/160] tools: hv: change permissions of NetworkManager configuration file
Date: Mon, 23 Dec 2024 16:57:19 +0100
Message-ID: <20241223155409.748837631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olaf Hering <olaf@aepfle.de>

[ Upstream commit 91ae69c7ed9e262f24240c425ad1eef2cf6639b7 ]

Align permissions of the resulting .nmconnection file, instead of
the input file from hv_kvp_daemon. To avoid the tiny time frame
where the output file is world-readable, use umask instead of chmod.

Fixes: 42999c904612 ("hv/hv_kvp_daemon:Support for keyfile based connection profile")
Signed-off-by: Olaf Hering <olaf@aepfle.de>
Reviewed-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Link: https://lore.kernel.org/r/20241016143521.3735-1-olaf@aepfle.de
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Message-ID: <20241016143521.3735-1-olaf@aepfle.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/hv/hv_set_ifconfig.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
index 440a91b35823..2f8baed2b8f7 100755
--- a/tools/hv/hv_set_ifconfig.sh
+++ b/tools/hv/hv_set_ifconfig.sh
@@ -81,7 +81,7 @@ echo "ONBOOT=yes" >> $1
 
 cp $1 /etc/sysconfig/network-scripts/
 
-chmod 600 $2
+umask 0177
 interface=$(echo $2 | awk -F - '{ print $2 }')
 filename="${2##*/}"
 
-- 
2.39.5



