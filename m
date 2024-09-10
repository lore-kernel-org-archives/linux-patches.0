Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA376171671;
	Tue, 10 Sep 2024 09:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962113; cv=none; b=hREfGsAh0/dHpzwTfkh5Ps8agCo0KSt4ODaKAGWtXBgm+86EAlZKuwOnnt8nUc5RdS8s4uoYi1xE33g1lL91/tBfGI7sz2DheHFiy1jWwY2tPnI6XX9RQlHQ7JmQdhL2gkETj/ae2h3jW9/YQ8H2jakK6CfrvGAmvyQP9mIT9Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962113; c=relaxed/simple;
	bh=oet/RAHOIHlZ9BsfNZDcc4KEUC5saFAGh5OVHEV0qIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgeqzXfboid4JoMHLU58ovM/0xaIkjOS/W8HosWThuLvah6mFGT2JHeh3ypiqhWt4ODY/ec28GeT4h11jwb1jRXd6/N/X7/7FvRmwiMKjD/XG1p7tS6EeUoVzdIWYjCCMpb2XbxAdhmteTsIJEbx9eULneA4GpJ1hgHlf62r65c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u3ukiFlB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u3ukiFlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54201C4CEC6;
	Tue, 10 Sep 2024 09:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962113;
	bh=oet/RAHOIHlZ9BsfNZDcc4KEUC5saFAGh5OVHEV0qIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u3ukiFlBVqsMGsln/GZfboCx+50VNdA+wqLHid+OpUJc7zzR/IZ7RngvznzTegvx5
	 5bRs7D6ocbgD83tuMb8+keyZqP1h16njUwVqbaBiI/Mnm9uLqQ/N2gb73c+cm3ZISC
	 A+tk7gK6PJJwI1Mnysb2JJkBGuXLKmcYW/PLM8kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Michal Simek <michal.simek@amd.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: [PATCH 6.10 299/375] dt-bindings: nvmem: Use soc-nvmem node name instead of nvmem
Date: Tue, 10 Sep 2024 11:31:36 +0200
Message-ID: <20240910092632.603005317@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Simek <michal.simek@amd.com>

commit a759d1f25182f51210c8831d71ce7ee81e0930f4 upstream.

Based on commit d8764d347bd7 ("dt-bindings: firmware: xilinx: Describe
soc-nvmem subnode") soc-nvmem should be used instead of simple nvmem that's
why also update example to have it described correctly everywhere.

Fixes: c7f99cd8fb6b ("dt-bindings: nvmem: Convert xlnx,zynqmp-nvmem.txt to yaml")
Cc: stable <stable@kernel.org>
Signed-off-by: Michal Simek <michal.simek@amd.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20240902142510.71096-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/nvmem/xlnx,zynqmp-nvmem.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/nvmem/xlnx,zynqmp-nvmem.yaml b/Documentation/devicetree/bindings/nvmem/xlnx,zynqmp-nvmem.yaml
index 917c40d5c382..1cbe44ab23b1 100644
--- a/Documentation/devicetree/bindings/nvmem/xlnx,zynqmp-nvmem.yaml
+++ b/Documentation/devicetree/bindings/nvmem/xlnx,zynqmp-nvmem.yaml
@@ -28,7 +28,7 @@ unevaluatedProperties: false
 
 examples:
   - |
-    nvmem {
+    soc-nvmem {
         compatible = "xlnx,zynqmp-nvmem-fw";
         nvmem-layout {
             compatible = "fixed-layout";
-- 
2.46.0



