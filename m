Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793AA17C9E9;
	Tue, 16 Jul 2024 15:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145236; cv=none; b=RbRLswOkLItTSXB70ZYgj8zo2FQeM89kxRmvCZvNN4DXcPB6c4tVlgoNBch02lhF8N1/DWznZeAhWfuD7MbbEuKKX8H4mbr8EscCuppIjRBhYk8CS8lfikgEZHwYNQZqVCisux2GI/YsOANEPgUY+YCE3jGR3MdMh6dto6i9xUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145236; c=relaxed/simple;
	bh=6JRBxBD8jeWBl3MKTdY74Vg7vEhxqgpxYByMqeMyFuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U4yucm4/o1mTbT/VCiOi7j/kDxrvA73b+upYodNAHCypm0iwDR+W74B9SuVmsLic4cfeTnPn5Ln5VfMbId9z2Jbb1/SfJ/RZXF/aHMVMawUIzhCfA6Nz0mFefjRRXXo0izyx2oI05C6K6lMnQCfP2lIQRS9XD4Ump0qmLbiFV9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAvYXubZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAvYXubZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5234C4AF0E;
	Tue, 16 Jul 2024 15:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145236;
	bh=6JRBxBD8jeWBl3MKTdY74Vg7vEhxqgpxYByMqeMyFuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aAvYXubZnJNbk5kvdwaWf6PIQ5xFdq4UWl26PHdv3QVSEnPF5lMzGmFwU6HRV1zeu
	 uSlU8FyR/uqw3EACH9+cLDXDqa4YsMTmBD/e3uG3SPO33UFITDA46cFHxXhSImKquF
	 t/5rLCUqqAMn23+f8VGV+YxA7TIX8mlKVyovAyvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 143/143] kbuild: rpm-pkg: avoid the warnings with dtbs listed twice
Date: Tue, 16 Jul 2024 17:32:19 +0200
Message-ID: <20240716152801.496893506@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit e3286434d220efb9a8b78f7241a5667974d2ec80 ]

After 8d1001f7bdd0 (kbuild: rpm-pkg: fix build error with CONFIG_MODULES=n),
the following warning "warning: File listed twice: *.dtb" is appearing for
every dtb file that is included.
The reason is that the commented commit already adds the folder
/lib/modules/%{KERNELRELEASE} in kernel.list file so the folder
/lib/modules/%{KERNELRELEASE}/dtb is no longer necessary, just remove it.

Fixes: 8d1001f7bdd0 ("kbuild: rpm-pkg: fix build error with CONFIG_MODULES=n")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/package/kernel.spec | 1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/package/kernel.spec b/scripts/package/kernel.spec
index fffc8af8deb17..c52d517b93647 100644
--- a/scripts/package/kernel.spec
+++ b/scripts/package/kernel.spec
@@ -83,7 +83,6 @@ ln -fns /usr/src/kernels/%{KERNELRELEASE} %{buildroot}/lib/modules/%{KERNELRELEA
 	done
 
 	if [ -d "%{buildroot}/lib/modules/%{KERNELRELEASE}/dtb" ];then
-		echo "/lib/modules/%{KERNELRELEASE}/dtb"
 		find "%{buildroot}/lib/modules/%{KERNELRELEASE}/dtb" -printf "%%%ghost /boot/dtb-%{KERNELRELEASE}/%%P\n"
 	fi
 
-- 
2.43.0



