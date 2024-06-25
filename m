Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60D6414A4D9;
	Tue, 25 Jun 2024 09:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309227; cv=none; b=ECTNQC+LQcERVulJ1A0Trt9xn3/s9saowvM1ZU+S1M6932SgsYSO9n1V0KoGvAilj01fU3Jo36UqobAVp/+zO70P3MY+vUvL+Ia7/XfKhSMdGGjzwetMApZlpW0W9PZMosBYJR+60kbZnu7VyLGJeBBcKwqQCQPc6XZyNE+tz5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309227; c=relaxed/simple;
	bh=jzxvZ9nvxrnBCVgWa2VpcOKSG0zXNdNbJud50Ane6gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPKWuWaqNWc+4nfKbiRVLAizhvvZ0Z42Jl05w+HxJj8BMmRSOAENtf03sIlFjAeoMJZ0pwowa4BlxF3MZdtIfMCelgOMeCRLpc/KN7gJfFS3nS1mYAXUaXmEncW8J2A8p2kgLlDy0tWMKlIhQoTYbkhLXbLBIJx3JNg1OagegFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdIBaA5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdIBaA5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9B6C32781;
	Tue, 25 Jun 2024 09:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309227;
	bh=jzxvZ9nvxrnBCVgWa2VpcOKSG0zXNdNbJud50Ane6gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdIBaA5yY66P3Zwalemep2zcBvCzakV3Pdin50P9qvCcIzHARN8aJGFpTLUW4KqcL
	 w2U0yUwoiTN7X4JtaBhsrHZ8u/UZCtjmAYPhlqD/DqmH5bBv9i6M8uNFHBEsUxqr7g
	 TlIK2lvp8AA7MhriBijh4WA+j7sILly1Ny+zHM7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 138/192] cifs: fix typo in module parameter enable_gcm_256
Date: Tue, 25 Jun 2024 11:33:30 +0200
Message-ID: <20240625085542.457247677@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Steve French <stfrench@microsoft.com>

commit 8bf0287528da1992c5e49d757b99ad6bbc34b522 upstream.

enable_gcm_256 (which allows the server to require the strongest
encryption) is enabled by default, but the modinfo description
incorrectly showed it disabled by default. Fix the typo.

Cc: stable@vger.kernel.org
Fixes: fee742b50289 ("smb3.1.1: enable negotiating stronger encryption by default")
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -133,7 +133,7 @@ module_param(enable_oplocks, bool, 0644)
 MODULE_PARM_DESC(enable_oplocks, "Enable or disable oplocks. Default: y/Y/1");
 
 module_param(enable_gcm_256, bool, 0644);
-MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: n/N/0");
+MODULE_PARM_DESC(enable_gcm_256, "Enable requesting strongest (256 bit) GCM encryption. Default: y/Y/0");
 
 module_param(require_gcm_256, bool, 0644);
 MODULE_PARM_DESC(require_gcm_256, "Require strongest (256 bit) GCM encryption. Default: n/N/0");


